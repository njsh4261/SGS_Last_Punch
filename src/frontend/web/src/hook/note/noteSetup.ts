import React, { useEffect } from 'react';
import { Params } from 'react-router-dom';
import { Editor, Node } from 'slate';
import { HistoryEditor } from 'slate-history';
import { ReactEditor } from 'slate-react';

import { Note } from '../../../types/note.type';
import { getSpecificNoteAPI } from '../../Api/note';
import { UserState } from '../../modules/user';

interface Props {
  note: Note | null;
  setNote: React.Dispatch<React.SetStateAction<Note | null>>;
  setTitle: React.Dispatch<React.SetStateAction<string>>;
  setValue: React.Dispatch<React.SetStateAction<Node[]>>;
  user: UserState;
  owner: UserState | null;
  editor: Editor & HistoryEditor & ReactEditor;
  params: Params;
  updateAllHandler: () => Promise<void>;
  resetTypingTimer: () => void;
  leaveNote: () => void;
}

export default function noteSetup(props: Props) {
  const {
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
  } = props;

  const getSpecificNoteHandler = async () => {
    const responseNote = await getSpecificNoteAPI(params.noteId!.toString());
    setNote(responseNote);
  };

  // 에디터 초기화
  useEffect(() => {
    const point = { path: [0, 0], offset: 0 };
    editor.selection = { anchor: point, focus: point }; // clean up selection
    editor.history = { redos: [], undos: [] }; // clean up history
  }, []);

  // GET note
  useEffect(() => {
    if (params.noteId) getSpecificNoteHandler();
  }, [params]);

  // 선점권을 갖자 마자 timer 동작 (특수키로 선점권 갖는 예외 상황)
  useEffect(() => {
    if (owner && owner.id === user.id) {
      resetTypingTimer();
    }
  }, [note, owner]);

  // API로 얻어진 note 정보 업데이트
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

  useEffect(() => {
    window.addEventListener('beforeunload', () => {
      if (owner && owner.id === user.id) {
        updateAllHandler();
      }
      leaveNote();
    });
  }, [note, owner]);
}
