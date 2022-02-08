import React from 'react';
import { useSelector, useDispatch } from 'react-redux';

import { Container, Layer } from '../../Common/DropdownComponent';
import { exitChannelAPI } from '../../../Api/channel';
import { RootState } from '../../../modules';
import { openModal } from '../../../modules/modal';

export default function DropdownChannel({
  id,
  channelId,
}: {
  id: string;
  channelId: any;
}) {
  const user = useSelector((state: RootState) => state.user);

  const dispatch = useDispatch();

  const inviteHandler = async () => {
    dispatch(openModal('invite-channel'));
  };

  const exitHandler = async () => {
    const response = await exitChannelAPI(user.id, channelId);
    console.log('res:', response);
  };

  return (
    <Container id={id}>
      <Layer onClick={inviteHandler}>Invite</Layer>
      <Layer onClick={() => alert('todo: Detail')}>Detail</Layer>
      <Layer onClick={exitHandler} color="red">
        Exit
      </Layer>
    </Container>
  );
}
