import React from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import { RootState } from '../../../../modules';
import Modal from './Modal';
import getChannelsAndMembersHook from '../../../../hook/getChannelsAndMembers';
import selectChannelHook from '../../../../hook/selectChannel';
import ToggleList, { Label } from './ToggleList';

const Container = styled.article`
  padding-top: 8px;
  display: flex;
  flex-direction: column;
  color: ${({ theme }) => theme.color.snackSideFont};
  font-size: 14px;
  /* overflow-x: hidden; */
  height: 100%;
  :hover,
  :focus {
    overflow-y: auto;
  }
`;

const SecitonType = styled.section`
  padding: 8px 0px;
  &:hover {
    background-color: ${(props) => props.theme.color.snackSideHover};
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
        type="direct message"
      ></ToggleList>
    </Container>
  );
}
