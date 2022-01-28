import React, { useState, useMemo } from 'react';
import styled from 'styled-components';
import EditorFrame from './EditorFrame';
import { createEditor, Node } from 'slate';
import { withHistory } from 'slate-history';
import { withReact } from 'slate-react';

const Container = styled.article`
  display: flex;
  flex-direction: column;
  margin: 0 96px;
  height: 100%;
`;

export default function NoteMain() {
  const [value, setValue] = useState<Node[]>([
    {
      type: 'paragraph',
      children: [{ text: 'A line of text in a paragraph.' }],
    },
  ]);

  const editor = useMemo(() => withReact(withHistory(createEditor())), []);

  return (
    <Container>
      <EditorFrame
        value={value}
        onChange={setValue}
        editor={editor}
      ></EditorFrame>
    </Container>
  );
}
