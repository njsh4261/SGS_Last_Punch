import React, { useState, useMemo, useRef, useEffect } from 'react';
import styled from 'styled-components';
import { createEditor, Node, Text, Transforms, Editor } from 'slate';
import { withHistory } from 'slate-history';
import { withReact } from 'slate-react';
import { useParams } from 'react-router-dom';

import EditorFrame from './EditorFrame';
import { Note } from '../../../../types/note.type';
import noteSocketHook from '../../../hook/noteSocket';
import { User } from '../../../hook/noteSocket';
import {
  updateNoteAllAPI,
  updateNoteOPAPI,
  getSpecificNoteAPI,
  updateTitleAPI,
} from '../../../Api/note';

const TYPING_TIME = 2000;
const UPDATE_OP_TIME = 1000;
const UPDATE_NOTE_TIME = 10000;

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

export default function NoteMain() {
  const initialValue = [
    {
      type: 'paragraph',
      children: [{ text: '' }],
    },
  ];

  const params = useParams();
  const [note, setNote] = useState<Note | null>(null);
  const [value, setValue] = useState<Node[]>(initialValue);
  const editor = useMemo(() => withReact(withHistory(createEditor())), []);

  const {
    updateNote,
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
  const opQueue = useRef<any[]>([]);

  const changeHandler = async (value: Node[]) => {
    setValue(value);
    const ops = editor.operations.filter((op) => {
      if (op) return op.type !== 'set_selection';
      return false;
    });

    // todo: op를 배열에 저장하고 수초에 한번씩 call API to note server
    if (ops.length > 0) {
      opQueue.current.push(...ops);
    }
  };

  /**
   * 키 입력시 선점에 대한 핸들링
   * @ 선점자: 입력 허용
   * @ 비선점자: 선점자가 있으면 입력 금지, 없으면 선점 요창
   */
  const keydownHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    const arrowKeys = ['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'];
    if (arrowKeys.includes(e.key)) {
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

      if (typing.current) clearTimeout(typing.current);
      typing.current = setTimeout(() => {
        endtypingHandler();
      }, TYPING_TIME);
      return;
    }

    // 비선점자 처리
    e.preventDefault();
    if (owner === null) {
      lockNote();
    }
  };

  const updateHandler = async () => {
    if (!note) return;
    const { id } = note;
    console.log('send:', JSON.stringify(value));
    const res = await updateNoteAllAPI(id, title, JSON.stringify(value));
    if (res) console.log('updated note all!');
    else alert('fail update');
  };

  const getSpecificNoteHandler = async () => {
    const responseNote = await getSpecificNoteAPI(params.noteId!.toString());
    setNote(responseNote);
  };

  const endtypingHandler = () => {
    console.log('end typing');
    updateHandler();
    unlockNote();
  };

  useEffect(() => {
    if (params.noteId) getSpecificNoteHandler();
  }, [params]);

  // owner가 입력할 때에 대한 처리
  useEffect(() => {
    // 선점권을 갖자 마자 unlock을 위한 시간 체크
    if (owner && owner.id === myUser.id) {
      typing.current = setTimeout(() => {
        endtypingHandler();
      }, TYPING_TIME);

      // 주기마다 update OP
      const opTimer = setInterval(async () => {
        if (opQueue.current.length > 0) {
          const stringOP = JSON.stringify(opQueue.current);
          const timestamp = await updateNoteOPAPI(note!.id, stringOP);
          if (timestamp) {
            updateNote(timestamp);
            opQueue.current = [];
          } else console.error('update fail - Note/main/index');
        }
      }, UPDATE_OP_TIME);

      const noteTimer = setInterval(() => updateHandler, UPDATE_NOTE_TIME);

      return () => {
        clearInterval(opTimer);
        clearInterval(noteTimer);
      };
    }
  }, [owner, note]);

  useEffect(() => {
    if (note) {
      try {
        // apply title
        setTitle(note.title);

        // apply content
        const content = JSON.parse(note.content);
        setValue(content);

        // apply ops
        const { ops } = note;
        Editor.withoutNormalizing(editor, () => {
          ops.forEach((op: any) => editor.apply(JSON.parse(op)));
        });
      } catch (e) {
        console.error('Wrong Format - note.content');
      }
    }
  }, [note]);

  const titleHandler = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (owner === null) {
      lockNote();
    } else if (owner.id === myUser.id) {
      setTitle(e.target.value);

      if (typingTitle.current) clearTimeout(typingTitle.current);
      typingTitle.current = setTimeout(() => {
        updateTitleAPI(note!.id, e.target.value);
        unlockNote();
      }, TYPING_TIME);
    }
  };

  window.addEventListener('beforeunload', () => {
    updateHandler();
    leaveNote();
  });

  return (
    <>
      {!note ? (
        <div>select any note</div>
      ) : (
        <Container>
          <label htmlFor="title-input">
            <h1>{title}</h1>
          </label>
          <InvisibleInput
            id="title-input"
            value={title}
            onChange={titleHandler}
          ></InvisibleInput>
          <button onClick={updateHandler}>update</button>
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
