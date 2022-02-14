import React from 'react';

import ChannelModal from './ChannelModal';
import InviteModal from '../../../Common/InviteModal';
import ModalBox from '../../../Common/ModalBox';

export type ModalType =
  | 'channel'
  | 'workspace'
  | 'direct message'
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
