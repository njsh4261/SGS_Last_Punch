import React, { useEffect } from 'react';
import { Editor, Node } from 'slate';
import { HistoryEditor } from 'slate-history';
import { ReactEditor } from 'slate-react';

import { Note } from '../../../types/note.type';

interface HookProps {
  note: Note | null;
  setTitle: React.Dispatch<React.SetStateAction<string>>;
  setValue: React.Dispatch<React.SetStateAction<Node[]>>;
  editor: Editor & HistoryEditor & ReactEditor;
}

export default function noteApplyInitDataHook(props: HookProps) {
  const { note, setTitle, setValue, editor } = props;
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
}
