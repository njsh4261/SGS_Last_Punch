import React from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import { RootState } from '../../../../modules';
import Modal from '../../../Common/ModalCreateOrInvite';
import getChannelsAndMembersHook from '../../../../hook/getChannelsAndMembers';
import selectChannelHook from '../../../../hook/selectChannel';
import ToggleList from './ToggleList';

const Container = styled.article`
  padding-top: 8px;
  padding-bottom: 130px;
  display: flex;
  flex-direction: column;
  color: ${({ theme }) => theme.color.snackSideFont};
  font-size: 14px;
  height: 100%;
  :hover,
  :focus {
    overflow-y: auto;
  }
`;

export default function AsideBody() {
  const [params] = getChannelsAndMembersHook();
  const selectChannelHandler = selectChannelHook(params);
  const modalState = useSelector((state: RootState) => state.modal);
  const channelList = useSelector((state: RootState) => state.channelList);
  const memberList = useSelector((state: RootState) => state.userList);

  return (
    <Container>
      {modalState.active &&
        (modalState.modalType === 'newChannel' ||
          modalState.modalType === 'direct message' ||
          modalState.modalType === 'invite-channel' ||
          modalState.modalType === 'invite-workspace') && (
          <Modal type={modalState.modalType} wsId={params.wsId}></Modal>
        )}
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
