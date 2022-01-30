import React, { useState, useMemo, useRef } from 'react';
import styled from 'styled-components';
import EditorFrame from './EditorFrame';
import { createEditor, Node } from 'slate';
import { withHistory } from 'slate-history';
import { withReact } from 'slate-react';
import noteSocketHook from '../../../hook/noteSocket';
import noteUserListHook from '../../../hook/noteUserList';
import { User } from '../../../hook/noteSocket';

const Container = styled.article`
  display: flex;
  flex-direction: column;
  width: 50%;
  margin: 0 96px;
  height: 100%;
`;

export default function NoteMain() {
  const initialValue = [
    {
      type: 'paragraph',
      children: [{ text: 'A line of text in a paragraph.' }],
    },
  ];
  const [value, setValue] = useState<Node[]>(initialValue);
  const editor = useMemo(() => withReact(withHistory(createEditor())), []);
  const { updateNote, remote, lockNote, unlockNote, owner, myUser, userList } =
    noteSocketHook(editor);
  const { userListState } = noteUserListHook({ userList });

  type Timeout = ReturnType<typeof setTimeout>;
  const typing = useRef<Timeout | null>(null);

  const changeHandler = (value: Node[]) => {
    setValue(value);
    const ops = editor.operations.filter((op) => {
      if (op) return op.type !== 'set_selection';
      return false;
    });

    // op를 배열에 저장하고 수초에 한번씩 call API to note server
    if (ops.length > 0 && !remote.current) {
      updateNote();
      remote.current = false;
    }

    if (typing.current) clearTimeout(typing.current);
    typing.current = setTimeout(() => {
      console.log('end typing');
      unlockNote();
    }, 1000);
  };

  /**
   * 키 입력시 선점에 대한 핸들링
   * @ 선점자: 입력 허용
   * @ 비선점자: 선점자가 있으면 입력 금지, 없으면 선점 요창
   */
  const keydownHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    if (owner.current === myUser) return;

    e.preventDefault();
    if (owner.current !== null) return;
    lockNote();
    return;
  };

  return (
    <Container>
      <EditorFrame
        value={value}
        onChange={changeHandler}
        onKeyDown={keydownHandler}
        editor={editor}
      ></EditorFrame>
      {userListState.map((u: User) => (
        <div key={u.id}>{JSON.stringify(u)}</div>
      ))}
    </Container>
  );
}
