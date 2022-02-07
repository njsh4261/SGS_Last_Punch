import React from 'react';
import styled from 'styled-components';

import ChannelModal from './ChannelModal';
import InviteModal from './InviteModal';

const Container = styled.article`
  position: absolute;
  z-index: 1;
  width: 520px;
  background-color: white;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  border-radius: 8px;
  box-shadow: 0 18px 48px 0 rgba(0, 0, 0, 0.35);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  font-family: NotoSansKR, Slack-Lato, appleLogo, sans-serif;
  font-size: 15px;
  color: black;
  letter-spacing: 0.5px;
`;

export type ModalType = 'channel' | 'direct message';

export default function Modal({
  type,
  wsId,
}: {
  type: ModalType;
  wsId?: string;
}) {
  return (
    <Container>
      {type === 'channel' ? (
        <ChannelModal></ChannelModal>
      ) : (
        <InviteModal wsId={wsId!}></InviteModal>
      )}
    </Container>
  );
}
