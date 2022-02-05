import React from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';
import { useParams } from 'react-router-dom';

import { openModal } from '../../../../modules/modal';
import { ModalType } from './Modal';
import ChannelItem, { ItemContainer } from './ChannelItem';

const ToggleType = styled.section`
  padding: 8px 0px;
`;

const PaddingLeft8px = styled.span`
  padding-left: 8px;
`;

export const Text = styled.label`
  display: block;
  padding: 0 16px;
  width: 260px;
  overflow-x: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
  &:hover {
    color: gray;
  }
`;

const CheckBox = styled.input`
  display: none;
`;

const ChannelList = styled.article`
  padding: 7px 8px 0;
  margin: 0;
  display: none;

  ${CheckBox}:checked + & {
    display: block;
  }
`;

const Flex = styled.div`
  display: flex;
`;

const PlusIcon = styled.div`
  display: inline-block;
  padding: 0 4px 2px;
  background-color: rgb(207, 195, 207);
  border-radius: 4px;
  color: ${(props) => props.theme.color.slack};
`;

interface Props {
  type: ModalType;
  channelList: Array<{ id: string; name: string }>;
  selectHandler: (e: React.MouseEvent<HTMLDivElement>) => void;
}

export default function ToggleList({
  channelList,
  selectHandler,
  type,
}: Props) {
  const params = useParams();
  const dispatch = useDispatch();
  const openModalHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const modalType = (e.currentTarget as HTMLDivElement).dataset
      .type as ModalType;
    dispatch(openModal(modalType));
  };
  return (
    <ToggleType>
      <Text htmlFor={`${type}-toggle`}>
        <Flex>
          ▶️
          <PaddingLeft8px>{type}</PaddingLeft8px>
        </Flex>
      </Text>
      <CheckBox type="checkbox" id={`${type}-toggle`}></CheckBox>
      <ChannelList>
        {channelList.map((channel) => (
          <ChannelItem
            channel={channel}
            wsId={params.wsId as string}
            key={channel.id}
            type={type}
            selectHandler={selectHandler}
            isSelected={params.channelId === channel.id.toString()}
          ></ChannelItem>
        ))}
        <ItemContainer data-type={type} onClick={openModalHandler}>
          <PlusIcon>+</PlusIcon>
          {type === 'channel' ? (
            <PaddingLeft8px>채널 추가</PaddingLeft8px>
          ) : (
            <PaddingLeft8px>팀원 추가</PaddingLeft8px>
          )}
        </ItemContainer>
      </ChannelList>
    </ToggleType>
  );
}
