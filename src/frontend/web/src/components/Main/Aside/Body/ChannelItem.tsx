import React, { useState, useEffect } from 'react';
import styled from 'styled-components';

import { ModalType } from './Modal';
import {
  createNoteAPI,
  getNoteListAPI,
  getSpecificNoteAPI,
} from '../../../../Api/note';

export const ItemContainer = styled.section`
  padding: 7px 0 7px 26px;

  &:hover {
    cursor: pointer;
    background: ${(props) => props.theme.color.heavySlack};
  }
`;

const PaddingLeft8px = styled.span`
  padding-left: 8px;
`;

interface Props {
  channel: {
    id: string;
    name: string;
  };
  type: ModalType;
  isSelected?: boolean;
  selectHandler: (e: React.MouseEvent<HTMLDivElement>) => void;
}

export default function ChannelItem(props: Props) {
  const { channel, selectHandler, type, isSelected } = props;

  const [noteList, setNoteList] = useState<any[]>([]);
  const [selectedNote, selectNote] = useState();

  const testCreateHandler = async () => {
    const noteId = await createNoteAPI(1, 1, 1);
    if (noteId) setNoteList([...noteList, noteId]);
  };

  const testGetListHandler = async () => {
    const responseNoteList = await getNoteListAPI(+channel.id);
    if (responseNoteList)
      setNoteList(responseNoteList.map((resNote) => resNote.id));
  };

  const testGetSpecificHandler = async (
    e: React.MouseEvent<HTMLDivElement>,
  ) => {
    const responseNote = await getSpecificNoteAPI((e.target as any).id);
    // { id, creatorId, title, content(initValue), ops(null | []), createDt, modifyDt}
    selectNote(responseNote);
    // todo: change View this note (Main) redux?
  };

  useEffect(() => {
    if (isSelected) testGetListHandler();
  });

  return (
    <ItemContainer id={channel.id} data-type={type} onClick={selectHandler}>
      <div>
        #<PaddingLeft8px>{channel.name}</PaddingLeft8px>
      </div>
      {isSelected && <button onClick={testCreateHandler}>create note</button>}
      {isSelected &&
        noteList.map((note) => (
          <div id={note} key={note} onClick={testGetSpecificHandler}>
            {note}
          </div>
        ))}
    </ItemContainer>
  );
}
