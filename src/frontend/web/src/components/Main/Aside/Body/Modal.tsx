import React from 'react';
import styled from 'styled-components';

import ChannelModal from './ChannelModal';
import InviteModal from '../../../Common/InviteModal';
import ModalBox from '../../../Common/ModalBox';

export type ModalType =
  | 'channel'
  | 'invite-dm'
  | 'invite-channel'
  | 'invite-workspace';

export default function Modal({
  type,
  wsId,
}: {
  type: ModalType;
  wsId?: string;
}) {
  return (
    <ModalBox>
      {type === 'channel' ? (
        <ChannelModal></ChannelModal>
      ) : (
        <InviteModal type={type} wsId={wsId!}></InviteModal>
      )}
    </ModalBox>
  );
}
