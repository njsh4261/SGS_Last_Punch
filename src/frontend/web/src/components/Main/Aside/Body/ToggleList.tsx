import React, { useState } from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';
import { useParams } from 'react-router-dom';

import { openModal } from '../../../../modules/modal';
import { ModalType } from './Modal';
import ChannelItem, { ItemContainer } from './ChannelItem';
import addIcon from '../../../../icon/add.svg';
import { ChannelListState } from '../../../../modules/channeList';
import { UserState } from '../../../../modules/user';

const ToggleType = styled.section`
  padding: 8px 0px;
`;

const PaddingLeft8px = styled.span`
  padding-left: 8px;
`;

export const Label = styled.label`
  display: block;
  padding: 0 16px;
  width: 260px;
  overflow-x: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
  &:hover {
    color: black;
    font-weight: bolder;
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

const PlusIcon = styled.img`
  opacity: 50%;
`;

const ArrowDown = styled.div`
  display: inline-block;
  width: 0px;
  height: 0px;
  border-top: 10px solid darkgray;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
`;

const ArrowRight = styled.div`
  display: inline-block;
  width: 0px;
  height: 0px;
  border-left: 10px solid darkgray;
  border-top: 5px solid transparent;
  border-bottom: 5px solid transparent;
`;

interface Props {
  type: ModalType;
  channelList: ChannelListState | UserState[];
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
  const [checked, setChecked] = useState(false);
  return (
    <ToggleType>
      <Label htmlFor={`${type}-toggle`} onClick={() => setChecked(!checked)}>
        {checked ? <ArrowDown /> : <ArrowRight />}
        <PaddingLeft8px>{type}</PaddingLeft8px>
      </Label>
      <CheckBox type="checkbox" id={`${type}-toggle`}></CheckBox>
      <ChannelList>
        {channelList.map((channel) => (
          <ChannelItem
            channel={channel}
            paramChannelId={params.channelId}
            wsId={params.wsId as string}
            key={channel.id}
            type={type}
            selectHandler={selectHandler}
            isSelected={params.channelId === channel.id.toString()}
          ></ChannelItem>
        ))}
        <ItemContainer data-type={type} onClick={openModalHandler}>
          <Flex>
            <PlusIcon src={addIcon} width="16px" height="16px"></PlusIcon>
            {type === 'channel' ? (
              <PaddingLeft8px>채널 추가</PaddingLeft8px>
            ) : (
              <PaddingLeft8px>DM 추가</PaddingLeft8px>
            )}
          </Flex>
        </ItemContainer>
      </ChannelList>
    </ToggleType>
  );
}
