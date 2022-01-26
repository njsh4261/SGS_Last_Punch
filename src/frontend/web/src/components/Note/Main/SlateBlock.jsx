import React, { useMemo, useState } from 'react';
import { createEditor } from 'slate';
import { Slate, Editable, withReact, ReactEditor } from 'slate-react';
import { withHistory } from 'slate-history';

export default function SlateBlock() {
  // todo: get from server using api
  const initialValue = [
    {
      type: 'paragraph',
      children: [{ text: 'A line of text in a paragraph.' }],
    },
  ];
  const initialEditor = createEditor();
  // const editor = useMemo(() => withReact(createEditor()), [])
  const [editor] = useState(withReact(withHistory(initialEditor)));
  const [value, setValue] = useState(initialValue);
  const [ops, setOps] = useState([]);

  const handleChange = (newValue) => {
    // console.log(editor.operations, newValue);
    // setValue(newValue);
    if (editor.operations.length > 0) {
      editor.operations.map((op) => {
        const newOps = [];
        if (op.type !== 'set_selection') {
          newOps.push(op);
        }
        setOps([...ops, ...newOps]);
        return false;
      });
    }
  };

  const handleSendButton = () => {
    if (ops.length > 0) {
      console.log(ops);
      // send ops
      setOps([]);
    } else alert('ops is empty');
  };

  return (
    <>
      <button onClick={handleSendButton}>replayOP</button>
      <Slate editor={editor} value={value} onChange={handleChange}>
        <Editable style={{ border: '1px solid #c0c0c0', padding: '1em' }} />
      </Slate>
    </>
  );
}
