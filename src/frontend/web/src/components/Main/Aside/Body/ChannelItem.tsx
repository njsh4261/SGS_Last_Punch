import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';

import { ModalType } from './Modal';
import { createNoteAPI, getNoteListAPI } from '../../../../Api/note';

export const ItemContainer = styled.section`
  padding: 7px 0 7px 26px;
`;

const ChannelLayer = styled.div`
  display: flex;
  &:hover {
    cursor: pointer;
    color: black;
    font-weight: bolder;
  }
`;

const ChannelName = styled.section<{ newMessage: boolean }>`
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: 200px;
  font-weight: ${({ newMessage }) => newMessage && 'bolder'};
  font-style: ${({ newMessage }) => newMessage && 'italic'};
`;

const PaddingLeft8px = styled.span`
  padding-left: 8px;
`;

interface Props {
  channel: any;
  paramChannelId: string | undefined;
  wsId: string;
  type: ModalType;
  isSelected?: boolean;
  alarm?: boolean;
  selectHandler: (e: React.MouseEvent<HTMLDivElement>) => void;
}

export default function ChannelItem(props: Props) {
  const { channel, wsId, paramChannelId, selectHandler, type, isSelected } =
    props;

  const [noteList, setNoteList] = useState<any[]>([]);

  const navigate = useNavigate();

  const createNoteHandler = async () => {
    const noteId = await createNoteAPI(+wsId, +channel.id, 1);
    if (noteId) setNoteList([...noteList, noteId]);
  };

  const getNoteListHandler = async () => {
    const responseNoteList = await getNoteListAPI(+channel.id);
    if (responseNoteList)
      setNoteList(responseNoteList.map((resNote) => resNote.id));
  };

  const selectNoteHandler = async (e: React.MouseEvent<HTMLDivElement>) => {
    e.stopPropagation();
    const noteId = (e.target as any).id;
    if (noteId) navigate(`/${wsId}/${channel.id}/note/${noteId}`);
    else alert('no-note.id. aside-body-ChannelItem');
  };

  useEffect(() => {
    if (isSelected && type === 'channel') getNoteListHandler();
  }, [isSelected]);

  return (
    <ItemContainer id={channel.id} data-type={type} onClick={selectHandler}>
      <ChannelLayer>
        <ChannelName
          newMessage={channel.alarm && channel.id.toString() !== paramChannelId}
        >
          #<PaddingLeft8px>{channel.name}</PaddingLeft8px>
        </ChannelName>
        {type === 'channel' && isSelected && (
          <button onClick={createNoteHandler}>create note</button>
        )}
      </ChannelLayer>
      {type === 'channel' &&
        isSelected &&
        noteList.map((note) => (
          <div id={note} key={note} onClick={selectNoteHandler}>
            {note}
          </div>
        ))}
    </ItemContainer>
  );
}
