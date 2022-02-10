import React, { useState, useRef, useEffect } from 'react';
import styled from 'styled-components';
import { createEditor, Node, Editor } from 'slate';
import { HistoryEditor, withHistory } from 'slate-history';
import { ReactEditor, withReact } from 'slate-react';
import { useParams } from 'react-router-dom';

import EditorFrame from './EditorFrame';
import ImageButton from '../Common/ImageButton';
import arrowRightIcon from '../../icon/arrowRight.svg';
import { Note } from '../../../types/note.type';
import noteSocketHook, { User } from '../../hook/note/noteSocket';
import noteApplyInitDataHook from '../../hook/note/noteApplyInitData';
import {
  updateNoteAllAPI,
  getSpecificNoteAPI,
  updateTitleAPI,
} from '../../Api/note';
import noteOPintervalHook from '../../hook/note/noteOPinterval';
import Loading from '../Common/Loading';
import { toggleMark } from './EditorFrame/plugin/mark';
import { toggleBlock } from './EditorFrame/plugin/block';

import logoIcon from '../../icon/cookie-2.png';
import DropdownHook from '../../hook/Dropdown';
import DropdownSetting from '../Main/Chat/DropdownSetting';

const TYPING_TIME = 1500;
const UPDATE_OP_TIME = 1000;

const ARROW_KEYS = ['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'];

const Container = styled.article`
  display: flex;
  flex: 1;
  flex-direction: column;
  height: 100%;
  padding: 13px 20px;
`;

const Header = styled.header`
  display: flex;
  align-items: center;
  justify-content: space-between;
  user-select: none;
`;

const HeaderLeft = styled.div`
  display: flex;
`;

const NavTab = styled.nav`
  display: flex;
  position: relative;
`;

const NavButton = styled.img`
  cursor: pointer;

  :hover {
    animation: rotate_image 6s linear infinite;
  }
  @keyframes rotate_image {
    100% {
      transform: rotate(360deg);
    }
  }
`;

const H1 = styled.h1`
  margin: 0;
  padding-left: 8px;
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

const Body = styled.main`
  margin: 50px 50px 0 50px;
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
    user,
    userList,
    title,
    setTitle,
  } = noteSocketHook(editor, note);

  type Timeout = ReturnType<typeof setTimeout>;
  const typing = useRef<Timeout | null>(null);
  const typingTitle = useRef<Timeout | null>(null);
  const stringValue = useRef<string>(JSON.stringify(initialValue));
  const opQueue = useRef<any[]>([]);

  /////////////////// Handler //////////////////////

  const readOnlyHandler = () => {
    if (owner && owner.id !== user.id) return true;
    else return false;
  };

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

      resetTypingTimer();
      return;
    }

    // 비선점자라면 선점권 경쟁 충돌을 방지하기 위해 일단 이벤트를 막고 선점권 요청
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
    } else if (owner.id === user.id) {
      setTitle(e.target.value);

      if (typingTitle.current) clearTimeout(typingTitle.current);
      typingTitle.current = setTimeout(async () => {
        const success = await updateTitleAPI(note!.id, e.target.value);
        if (success) updateTitle();
        unlockNote();
      }, TYPING_TIME);
    }
  };

  ///////////// Hooks ////////////////

  useEffect(() => {
    const point = { path: [0, 0], offset: 0 };
    editor.selection = { anchor: point, focus: point }; // clean up selection
    editor.history = { redos: [], undos: [] }; // clean up history
  }, []);

  // get note from server - 현재 url에 적힌 noteId 바탕
  useEffect(() => {
    if (params.noteId) getSpecificNoteHandler();
  }, [params]);

  // apply note - 서버로부터 받은 노트 정보
  noteApplyInitDataHook({ note, setTitle, setValue, editor });

  // 선점권을 갖자 마자 unlock을 위한 시간 체크
  useEffect(() => {
    if (owner && owner.id === user.id) {
      resetTypingTimer();
    }
  }, [note, owner]);

  // 주기마다 op 업데이트
  noteOPintervalHook(opQueue, note, UPDATE_OP_TIME, updateNote);

  useEffect(() => {
    window.addEventListener('beforeunload', () => {
      if (owner && owner.id === user.id) {
        updateAllHandler();
      }
      leaveNote();
    });
  }, [note, owner]);

  ///////////// Render //////////////////////
  const { drop, dropdownHandler, NAV_BUTTON_ID, NAV_DROPDOWN_ID } =
    DropdownHook();
  return (
    <>
      {!note ? (
        <Loading></Loading>
      ) : (
        <Container>
          <Header>
            <HeaderLeft>
              {!sideToggle && (
                <ImageButton
                  size="16px"
                  imageUrl={arrowRightIcon}
                  onClick={sideToggleHandler}
                ></ImageButton>
              )}
              <label htmlFor="title-input">
                <H1>{title}</H1>
              </label>
              <InvisibleInput
                id="title-input"
                value={title}
                onChange={titleHandler}
              ></InvisibleInput>
            </HeaderLeft>
            <NavTab>
              <NavButton
                id={NAV_BUTTON_ID}
                src={logoIcon}
                onClick={dropdownHandler}
                width="26px"
                height="26px"
              ></NavButton>
              {drop && <DropdownSetting id={NAV_DROPDOWN_ID}></DropdownSetting>}
            </NavTab>
          </Header>
          <Body>
            <EditorFrame
              value={value}
              onChange={changeHandler}
              onKeyDown={keydownHandler}
              editor={editor}
              readOnly={readOnlyHandler()}
            ></EditorFrame>
          </Body>
          <TestContainer>
            <div>my: {JSON.stringify(user)}</div>
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
