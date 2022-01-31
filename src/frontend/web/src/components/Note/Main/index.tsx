import React, { useState, useMemo, useRef, useEffect } from 'react';
import styled from 'styled-components';
import EditorFrame from './EditorFrame';
import { createEditor, Node, Text, Transforms } from 'slate';
import { withHistory } from 'slate-history';
import { withReact } from 'slate-react';
import noteSocketHook from '../../../hook/noteSocket';
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
      // remote.current = false;
    }
  };

  /**
   * 키 입력시 선점에 대한 핸들링
   * @ 선점자: 입력 허용
   * @ 비선점자: 선점자가 있으면 입력 금지, 없으면 선점 요창
   */
  const keydownHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    console.log(
      `key: ${e.key},  meta:${e.metaKey},  ctrl:${e.ctrlKey} alt:${e.altKey},  shift:${e.shiftKey}`,
    );
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
        console.log('end typing');
        unlockNote();
      }, 1000);
      return;
    }
    e.preventDefault();
    if (owner === null) {
      lockNote();
    }
  };

  useEffect(() => {
    if (owner) {
      typing.current = setTimeout(() => {
        console.log('end typing');
        unlockNote();
      }, 1000);
    }
  }, [owner]);

  return (
    <Container>
      <EditorFrame
        value={value}
        onChange={changeHandler}
        onKeyDown={keydownHandler}
        editor={editor}
      ></EditorFrame>
      <div>my: {JSON.stringify(myUser)}</div>
      <div>owner: {JSON.stringify(owner)}</div>
      <div>
        userList:
        {userList.map((u: User) => (
          <div key={u.id}>{JSON.stringify(u)}</div>
        ))}
      </div>
    </Container>
  );
}
