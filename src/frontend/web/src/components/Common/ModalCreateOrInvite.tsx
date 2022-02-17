import React from 'react';

import ChannelModal from '../Main/Aside/Body/ChannelModal';
import InviteModal from './InviteModal';
import ModalBox from './ModalBox';
import { ModalType } from '../../../types/modal.type';

export default function Modal({
  type,
  wsId,
}: {
  type: ModalType;
  wsId?: string;
}) {
  return (
    <ModalBox>
      {type === 'newChannel' ? (
        <ChannelModal></ChannelModal>
      ) : (
        <InviteModal type={type} wsId={wsId!}></InviteModal>
      )}
    </ModalBox>
  );
}
