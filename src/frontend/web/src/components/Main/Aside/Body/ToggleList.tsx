import React from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';

import { openModal } from '../../../../modules/modal';
import expandIcon from '../../../../icon/downArrow.svg';
import ImageButton from '../../../Common/ImageButton';
import { ModalType } from './Modal';

const ToggleType = styled.section`
  padding: 8px 0px;
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
    color: white;
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

const ChannelItem = styled.section`
  padding: 7px 0 7px 26px;

  &:hover {
    cursor: pointer;
    background: ${(props) => props.theme.color.heavySlack};
  }
`;

const Flex = styled.div`
  display: flex;
`;

const PaddingLeft8px = styled.span`
  padding-left: 8px;
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
          <ImageButton
            size="17px"
            inline={true}
            imageUrl={expandIcon}
          ></ImageButton>
          <PaddingLeft8px>{type}</PaddingLeft8px>
        </Flex>
      </Text>
      <CheckBox type="checkbox" id={`${type}-toggle`}></CheckBox>
      <ChannelList>
        {channelList.map((channel) => (
          <ChannelItem
            id={channel.id}
            key={channel.id}
            data-type={type}
            onClick={selectHandler}
          >
            #<PaddingLeft8px>{channel.name}</PaddingLeft8px>
          </ChannelItem>
        ))}
        <ChannelItem data-type={type} onClick={openModalHandler}>
          <PlusIcon>+</PlusIcon>
          {type === 'channel' ? (
            <PaddingLeft8px>채널 추가</PaddingLeft8px>
          ) : (
            <PaddingLeft8px>팀원 추가</PaddingLeft8px>
          )}
        </ChannelItem>
      </ChannelList>
    </ToggleType>
  );
}
