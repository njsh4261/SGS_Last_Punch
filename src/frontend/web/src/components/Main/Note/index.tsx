import React, { useState, useRef } from 'react';
import styled from 'styled-components';
import { createEditor, Node, Editor } from 'slate';
import { HistoryEditor, withHistory } from 'slate-history';
import { ReactEditor, withReact } from 'slate-react';
import { useParams } from 'react-router-dom';

// type
import { Note } from '../../../../types/note.type';

// components
import EditorFrame from './EditorFrame';
import Loading from '../../Common/Loading';
import Header from './Header';

// hooks
import noteSetup from '../../../hook/note/noteSetup';
import noteSocketHook from '../../../hook/note/noteSocket';
import noteOPintervalHook from '../../../hook/note/noteOPinterval';

// API
import { updateNoteAllAPI } from '../../../Api/note';

// slate editor function
import { toggleMark } from './EditorFrame/plugin/mark';
import { toggleBlock } from './EditorFrame/plugin/block';

const TYPING_TIME = 1500;
const UPDATE_OP_TIME = 1000;

const ARROW_KEYS = ['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'];

const Container = styled.article`
  display: flex;
  flex: 1;
  flex-direction: column;
  height: 100%;
  overflow-x: hidden;
  padding: 13px 20px;
`;

const Body = styled.main`
  margin-top: 40px;
  padding: 0 50px;
  max-height: 100%;
  overflow-y: hidden;
  :hover {
    overflow-y: auto;
  }
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
  if (!editorRef.current)
    editorRef.current = withReact(withHistory(createEditor()));
  const editor = editorRef.current;
  type Timeout = ReturnType<typeof setTimeout>;
  const typing = useRef<Timeout | null>(null);
  const currentValue = useRef<Node[]>(initialValue);
  const opQueue = useRef<any[]>([]);

  // 선점자가 있으면 true를 리턴. text editor의 readOnly값.
  const readOnlyHandler = () => {
    if (owner && owner.id !== user.id) return true;
    else return false;
  };

  // typing timer를 초기화 시키는 핸들러.
  const resetTypingTimer = () => {
    if (typing.current) clearTimeout(typing.current);
    typing.current = setTimeout(() => {
      endtypingHandler();
    }, TYPING_TIME);
  };

  // 'keydownHandler'에 의해 선점자 판정을 받아야 수행 되는 핸들러.
  // 주기적으로 보낼 operation queue와 문서 전체의 value를 업데이트 한다.
  const changeHandler = async (value: Node[]) => {
    // 문서 정보 업데이트 (currnetValue: update API에서 사용)
    setValue(value);
    currentValue.current = value;

    // 드래그 이벤트는 무시
    const ops = editor.operations.filter((op) => {
      if (op) return op.type !== 'set_selection';
      return false;
    });

    // 선점자의 Op를 queue에 등록. API를 통해 DB에 저장.
    // 소켓을 통해 op update를 받은 다른 사용가 이 내용을 조회함.
    if (owner && owner.id === user.id && ops.length > 0) {
      opQueue.current.push(...ops);
    }
  };

  /**
   * 키 입력시 선점에 대한 핸들링
   * @ 선점자: 입력 허용
   * @ 비선점자: 선점자가 있으면 입력 금지, 없으면 선점 요창
   */
  const keydownHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    // 방향키 입력은 선점에 대한 이벤트로 보지 않음
    if (ARROW_KEYS.includes(e.key)) {
      return;
    }

    // 선점자일 때 단축키 처리
    if (owner && owner.id === user.id) {
      if (e.ctrlKey) {
        e.preventDefault();
        switch (e.key) {
          case 'b':
            toggleMark(editor, 'bold');
            break;
          case 'i':
            toggleMark(editor, 'italic');
            break;
          case 'u':
            toggleMark(editor, 'underline');
            break;
          case '`':
            toggleMark(editor, 'code');
            break;
          case '1':
            toggleBlock(editor, 'heading-one');
            break;
          case '2':
            toggleBlock(editor, 'heading-two');
            break;
          case '3':
            toggleBlock(editor, 'block-quote');
            break;
          case '4':
            toggleBlock(editor, 'bulleted-list');
            break;
          case '5':
            toggleBlock(editor, 'numbered-list');
            break;
        }
      }

      // 선점권의 타이핑이므로 typingTimer를 리셋.
      resetTypingTimer();
      return;
    }

    // 비선점자라면 선점권 경쟁 충돌을 방지하기 위해 일단 이벤트를 막고 선점권 요청
    e.preventDefault();
    if (owner === null) {
      lockNote();
    }
  };

  // 문서 전체를 업데이트 하는 핸들러. 타이핑 종료, 브라우저 종료 시에 호출 됨.
  const updateAllHandler = async () => {
    if (!note) return;
    const { id } = note;
    const res = await updateNoteAllAPI(
      id,
      title,
      JSON.stringify(currentValue.current),
    );
    if (!res) console.error('update note all fail');
  };

  // 타이핑 종료되는 시점에 호출되는 핸들러. 문서 업데이트와 선점권 해제.
  const endtypingHandler = () => {
    updateAllHandler();
    unlockNote();
  };

  ///////////// Hooks ////////////////

  // 노트 소켓 훅
  const {
    updateNote, // 소켓에 노트의 업데이트 사실을 알리는 함수 (받으면 op를 업데이 API를 호출함)
    updateTitle,
    lockNote, // 소켓에 선점권 요청을 하는 함수.
    unlockNote, // 선점권 해제를 하는 함수.
    leaveNote, // note를 떠났다는 것을 소켓에 알리는 함수.
    owner, // 현재 선점자
    user, // 내 정보
    title, // 현재 제목
    setTitle, // 제목 변경 함수 (React.Dispatch<React.SetStateAction<string>>)
  } = noteSocketHook(editor, note);

  // 노트 세팅 (GET NOTE API, editor에 적용, 특수키 선점시 타이머(예외처리) )
  noteSetup({
    note,
    setNote,
    setTitle,
    setValue,
    user,
    owner,
    editor,
    params,
    leaveNote,
    resetTypingTimer,
    updateAllHandler,
  });

  // 주기마다 op 업데이트
  noteOPintervalHook(opQueue, note, UPDATE_OP_TIME, updateNote);

  ///////////// Render //////////////////////
  return (
    <>
      {!note ? (
        <Loading></Loading>
      ) : (
        <Container>
          <Header
            sideToggle={sideToggle}
            sideToggleHandler={sideToggleHandler}
            owner={owner}
            user={user}
            note={note}
            lockNote={lockNote}
            unlockNote={unlockNote}
            TYPING_TIME={TYPING_TIME}
            title={title}
            setTitle={setTitle}
            updateTitle={updateTitle}
          ></Header>
          <Body>
            <EditorFrame
              value={value}
              onChange={changeHandler}
              onKeyDown={keydownHandler}
              editor={editor}
              readOnly={readOnlyHandler()}
            ></EditorFrame>
          </Body>
        </Container>
      )}
    </>
  );
}
