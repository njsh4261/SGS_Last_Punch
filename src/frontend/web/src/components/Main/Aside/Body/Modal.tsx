import React from 'react';

import ChannelModal from './ChannelModal';
import InviteModal from '../../../Common/InviteModal';
import ModalBox from '../../../Common/ModalBox';
import { ModalType } from '../../../../../types/modal.type';

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
