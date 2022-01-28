import React from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import { RootState } from '../../../../modules';
import Modal from './Modal';
import getChannelsAndMembersHook from '../../../../hook/getChannelsAndMembers';
import selectChannelHook from '../../../../hook/selectChannel';
import setTitleHook from '../../../../hook/setTitle';
import ToggleList, { Text } from './ToggleList';

const Container = styled.article`
  padding-top: 8px;
  display: flex;
  flex-direction: column;
  color: rgb(207, 195, 207);
  font-size: 14px;
  overflow-y: scroll;
`;

const SecitonType = styled.section`
  padding: 8px 0px;
  &:hover {
    background-color: ${(props) => props.theme.color.heavySlack};
  }
`;

export default function AsideBody() {
  // todo: get more list channel/member
  const [channelList, memberList, params] = getChannelsAndMembersHook();
  setTitleHook('', params);
  const selectChannelHandler = selectChannelHook(params);
  const modalState = useSelector((state: RootState) => state.modal);

  return (
    <Container>
      {modalState.active && <Modal type={modalState.modalType}></Modal>}
      <SecitonType>
        <Text>알림</Text>
      </SecitonType>
      <ToggleList
        channelList={channelList}
        selectHandler={selectChannelHandler}
        type="channel"
      ></ToggleList>
      <ToggleList
        channelList={memberList}
        selectHandler={selectChannelHandler}
        type="direct message"
      ></ToggleList>
    </Container>
  );
}
