import React, { useState, useMemo } from 'react';
import styled from 'styled-components';
import EditorFrame from './EditorFrame';
import { createEditor, Node } from 'slate';
import { withHistory } from 'slate-history';
import { withReact } from 'slate-react';
import noteSocketHook from '../../../hook/noteSocket';

const Container = styled.article`
  display: flex;
  flex-direction: column;
  width: 70%;
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
  const [sendMessage, remote] = noteSocketHook(editor);

  const changeHandler = (value: Node[]) => {
    setValue(value);
    const ops = editor.operations.filter((op) => {
      if (op) return op.type !== 'set_selection';
      return false;
    });
    if (ops.length > 0 && !remote.current) {
      sendMessage(ops);
      remote.current = false;
    }
  };

  return (
    <Container>
      <EditorFrame
        value={value}
        onChange={changeHandler}
        editor={editor}
      ></EditorFrame>
    </Container>
  );
}
