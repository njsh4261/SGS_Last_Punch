import React from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import { RootState } from '../../../../modules';
import Modal from './Modal';
import getChannelsAndMembersHook from '../../../../hook/getChannelsAndMembers';
import selectChannelHook from '../../../../hook/selectChannel';
import setTitleHook from '../../../../hook/setTitle';
import ToggleList, { Label } from './ToggleList';

const Container = styled.article`
  padding-top: 8px;
  display: flex;
  flex-direction: column;
  color: ${({ theme }) => theme.color.snackSideFont};
  font-size: 14px;
  overflow-y: scroll;
`;

const SecitonType = styled.section`
  padding: 8px 0px;
  &:hover {
    background-color: ${(props) => props.theme.color.snackSideHover};
  }
`;

export default function AsideBody() {
  const [params] = getChannelsAndMembersHook();
  setTitleHook('', params);
  const selectChannelHandler = selectChannelHook(params);
  const modalState = useSelector((state: RootState) => state.modal);
  const channelList = useSelector((state: RootState) => state.channelList);
  const memberList = useSelector((state: RootState) => state.userList);

  return (
    <Container>
      {modalState.active && (
        <Modal type={modalState.modalType} wsId={params.wsId}></Modal>
      )}
      <SecitonType>
        <Label>알림</Label>
      </SecitonType>
      <ToggleList
        channelList={channelList}
        selectHandler={selectChannelHandler}
        type="channel"
      ></ToggleList>
      <ToggleList
        channelList={memberList}
        selectHandler={selectChannelHandler}
        type="invite-dm"
      ></ToggleList>
    </Container>
  );
}
