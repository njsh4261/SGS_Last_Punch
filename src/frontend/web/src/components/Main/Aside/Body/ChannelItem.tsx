import React, { useState, useEffect } from 'react';
import { Params, useNavigate } from 'react-router-dom';
import styled from 'styled-components';

import { ModalType } from '../../../../../types/modal.type';
import { createNoteAPI, getNoteListAPI } from '../../../../Api/note';

export const ItemContainer = styled.section<{ isSelected?: boolean }>`
  padding: 7px 0 7px 26px;
  border-radius: 6px;
  margin-bottom: 6px;
  background-color: ${({ theme, isSelected }) =>
    isSelected && theme.color.snackSideHover};
  :hover {
    color: black;
    cursor: pointer;
  }
`;

const ChannelLayer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

interface ChannelNameProps {
  newMessage: boolean;
  isSelected: boolean;
}

const ChannelName = styled.section<ChannelNameProps>`
  padding: 3px 0 2px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: 125px;
  color: ${({ isSelected, newMessage }) =>
    (isSelected || newMessage) && 'black'};
  font-weight: ${({ newMessage }) => newMessage && 'bolder'};
`;

const ButtonCreateNote = styled.button`
  font-size: 14px;
  outline: none;
  border: none;
  background: inherit;
  color: ${({ theme }) => theme.color.snackSideFont};
  padding: 1px 4px 0px 4px;
  border: 1px solid ${({ theme }) => theme.color.snackSideFont};
  border-radius: 4px;
  margin-right: 10px;
  cursor: pointer;
  :hover {
    color: black;
    border: 1px solid black;
  }
`;

const NoteItem = styled.article<{ isSelected: boolean }>`
  padding: 7px 0px 0px 12px;
  width: 130px;
  outline: none;
  border: none;
  background: inherit;
  color: ${({ isSelected }) => (!!isSelected ? 'black' : 'inherit')};
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;

  :hover {
    cursor: pointer;
    color: black;
  }
`;

interface Props {
  channel: any;
  params: Params;
  wsId: string;
  type: ModalType;
  isSelected?: boolean;
  alarm?: boolean;
  selectHandler: (e: React.MouseEvent<HTMLDivElement>) => void;
}

export default function ChannelItem(props: Props) {
  const { channel, wsId, params, selectHandler, type, isSelected } = props;

  const [noteList, setNoteList] = useState<any[]>([]);
  const [hover, setHover] = useState(false);

  const navigate = useNavigate();

  const createNoteHandler = async () => {
    const note = await createNoteAPI(+wsId, +channel.id, 1);
    if (note) setNoteList([...noteList, note]);
  };

  const getNoteListHandler = async () => {
    const responseNoteList = await getNoteListAPI(+channel.id);
    if (responseNoteList)
      setNoteList(responseNoteList.map((resNote) => resNote));
  };

  const selectNoteHandler = async (e: React.MouseEvent<HTMLDivElement>) => {
    e.stopPropagation();
    const noteId = (e.target as Element).id;
    if (noteId) navigate(`/${wsId}/${channel.id}/note/${noteId}`);
    else alert('no-note.id. aside-body-ChannelItem');
  };

  const hoverHandler = () => setHover((current) => !current);

  useEffect(() => {
    if (isSelected && type === 'channel') getNoteListHandler();
  }, [isSelected]);

  return (
    <ItemContainer
      id={channel.id}
      data-type={type}
      onClick={selectHandler}
      isSelected={!!isSelected}
      onMouseEnter={hoverHandler}
      onMouseLeave={hoverHandler}
    >
      <ChannelLayer>
        <ChannelName
          newMessage={
            channel.alarm && channel.id.toString() !== params.channelId
          }
          isSelected={!!isSelected}
        >
          {`# ${channel.name}`}
        </ChannelName>
        {type === 'channel' && isSelected && hover && (
          <ButtonCreateNote onClick={createNoteHandler}>+</ButtonCreateNote>
        )}
      </ChannelLayer>
      {type === 'channel' &&
        isSelected &&
        noteList.map((note) => (
          <NoteItem
            id={`${note.id}`}
            key={`${note.id}`}
            isSelected={note.id === params.noteId}
            onClick={selectNoteHandler}
          >
            {note.title}
          </NoteItem>
        ))}
    </ItemContainer>
  );
}
