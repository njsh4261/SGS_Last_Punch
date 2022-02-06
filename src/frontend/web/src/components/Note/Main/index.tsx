import React, { useState, useRef, useEffect } from 'react';
import styled from 'styled-components';
import { createEditor, Node, Text, Transforms, Editor } from 'slate';
import { HistoryEditor, withHistory } from 'slate-history';
import { ReactEditor, withReact } from 'slate-react';
import { useParams } from 'react-router-dom';

import EditorFrame from './EditorFrame';
import ImageButton from '../../Common/ImageButton';
import arrowRightIcon from '../../../icon/arrowRight.svg';
import { Note } from '../../../../types/note.type';
import noteSocketHook, { User } from '../../../hook/note/noteSocket';
import noteApplyInitDataHook from '../../../hook/note/noteApplyInitData';
import {
  updateNoteAllAPI,
  getSpecificNoteAPI,
  updateTitleAPI,
} from '../../../Api/note';
import noteOPintervalHook from '../../../hook/note/noteOPinterval';

const TYPING_TIME = 2000;
const UPDATE_OP_TIME = 1000;
const UPDATE_NOTE_TIME = 10000;
const ARROW_KEYS = ['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'];

const Container = styled.article`
  display: flex;
  flex-direction: column;
  width: 500px;
  margin: 0 96px;
  height: 100%;
`;

const TestContainer = styled.div`
  margin-top: 50px;
`;

const InvisibleInput = styled.input`
  width: 0;
  height: 0;
  padding: 0;
  margin: 0;
  border: 0;
`;

interface Props {
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

export default function NoteMain({ sideToggle, sideToggleHandler }: Props) {
  const initialValue = [
    {
      type: 'paragraph',
      children: [{ text: '' }],
    },
  ];

  const params = useParams();
  const [note, setNote] = useState<Note | null>(null);
  const [value, setValue] = useState<Node[]>(initialValue);
  const editorRef = useRef<Editor & ReactEditor & HistoryEditor>();
  // const editor = useMemo(() => withReact(withHistory(createEditor())), []);
  if (!editorRef.current)
    editorRef.current = withReact(withHistory(createEditor()));
  const editor = editorRef.current;

  const {
    updateNote,
    updateTitle,
    lockNote,
    unlockNote,
    leaveNote,
    owner,
    myUser,
    userList,
    title,
    setTitle,
  } = noteSocketHook(editor, note);

  type Timeout = ReturnType<typeof setTimeout>;
  const typing = useRef<Timeout | null>(null);
  const typingTitle = useRef<Timeout | null>(null);
  const stringValue = useRef<string>(JSON.stringify(initialValue));
  const opQueue = useRef<any[]>([]);

  const resetTypingTimer = () => {
    if (typing.current) clearTimeout(typing.current);
    typing.current = setTimeout(() => {
      endtypingHandler();
    }, TYPING_TIME);
  };

  const changeHandler = async (value: Node[]) => {
    setValue(value);
    stringValue.current = JSON.stringify(value); // for update all api
    const ops = editor.operations.filter((op) => {
      if (op) return op.type !== 'set_selection';
      return false;
    });

    if (owner && owner.id === myUser.id && ops.length > 0) {
      opQueue.current.push(...ops);
    }
  };

  /**
   * 키 입력시 선점에 대한 핸들링
   * @ 선점자: 입력 허용
   * @ 비선점자: 선점자가 있으면 입력 금지, 없으면 선점 요창
   */
  const keydownHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    if (ARROW_KEYS.includes(e.key)) {
      return;
    }

    // 선점자 처리 로직
    if (owner && owner.id === myUser.id) {
      if (e.ctrlKey) {
        switch (e.key) {
          case 'b':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { bold: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
          case 'i':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { italic: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
          case 'u':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { underline: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
          case '`':
            e.preventDefault();
            Transforms.setNodes(
              editor,
              { code: true },
              { match: (n) => Text.isText(n), split: true },
            );
            break;
        }
      }

      resetTypingTimer();
      return;
    }

    // 비선점자 처리
    e.preventDefault();
    if (owner === null) {
      lockNote();
    }
  };

  const updateAllHandler = async () => {
    if (!note) return;
    const { id } = note;
    const res = await updateNoteAllAPI(id, title, stringValue.current);
    if (!res) console.error('update note all fail');
  };

  const getSpecificNoteHandler = async () => {
    const responseNote = await getSpecificNoteAPI(params.noteId!.toString());
    setNote(responseNote);
  };

  const endtypingHandler = () => {
    updateAllHandler();
    unlockNote();
  };

  const titleHandler = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (owner === null) {
      lockNote();
    } else if (owner.id === myUser.id) {
      setTitle(e.target.value);

      if (typingTitle.current) clearTimeout(typingTitle.current);
      typingTitle.current = setTimeout(async () => {
        const success = await updateTitleAPI(note!.id, e.target.value);
        if (success) updateTitle();
        unlockNote();
      }, TYPING_TIME);
    }
  };

  // get note from server - 현재 url에 적힌 noteId 바탕
  useEffect(() => {
    if (params.noteId) getSpecificNoteHandler();
  }, [params]);

  // apply note - 서버로부터 받은 노트 정보
  noteApplyInitDataHook({ note, setTitle, setValue, editor });

  // 선점권을 갖자 마자 unlock을 위한 시간 체크
  useEffect(() => {
    if (owner && owner.id === myUser.id) {
      resetTypingTimer();
    }
  }, [note, owner]);

  // 주기마다 op 업데이트
  noteOPintervalHook(opQueue, note, UPDATE_OP_TIME, updateNote);

  useEffect(() => {
    window.addEventListener('beforeunload', () => {
      if (owner && owner.id === myUser.id) {
        updateAllHandler();
      }
      leaveNote();
    });
  }, [note, owner]);

  return (
    <>
      {!note ? (
        <div>select any note</div>
      ) : (
        <Container>
          {!sideToggle && (
            <ImageButton
              size="16px"
              imageUrl={arrowRightIcon}
              onClick={sideToggleHandler}
            ></ImageButton>
          )}
          <label htmlFor="title-input">
            <h1>{title}</h1>
          </label>
          <InvisibleInput
            id="title-input"
            value={title}
            onChange={titleHandler}
          ></InvisibleInput>
          <button onClick={updateAllHandler}>update</button>
          <EditorFrame
            value={value}
            onChange={changeHandler}
            onKeyDown={keydownHandler}
            editor={editor}
          ></EditorFrame>
          <TestContainer>
            <div>my: {JSON.stringify(myUser)}</div>
            <div>owner: {JSON.stringify(owner)}</div>
            <div>
              userList:
              {userList.map((u: User) => (
                <div key={u.id}>{JSON.stringify(u)}</div>
              ))}
            </div>
          </TestContainer>
        </Container>
      )}
    </>
  );
}
