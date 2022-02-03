import React from 'react';

import { Note } from '../../../types/note.type';
import useInterval from '../useInterval';
import { updateNoteOPAPI } from '../../Api/note';

export default function noteOPintervalHook(
  opQueue: React.MutableRefObject<any[]>,
  note: Note | null,
  UPDATE_OP_TIME: number,
  updateNote: (timestamp: string) => void,
) {
  useInterval(async () => {
    if (note && opQueue.current.length > 0) {
      console.log(note.id);
      const oldQueueLength = opQueue.current.length;
      const stringOP = JSON.stringify(opQueue.current);
      const timestamp = await updateNoteOPAPI(note.id, stringOP);
      if (timestamp) {
        updateNote(timestamp);
        if (oldQueueLength !== opQueue.current.length) {
          opQueue.current = opQueue.current.slice(oldQueueLength);
        } else opQueue.current = [];
      } else console.error('update fail - Note/main/index');
    }
  }, UPDATE_OP_TIME);
}
