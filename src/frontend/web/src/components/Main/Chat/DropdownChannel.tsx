import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';

import { Container, Layer } from '../../Common/DropdownComponent';
import { exitChannelAPI } from '../../../Api/channel';
import { RootState } from '../../../modules';

export default function DropdownChannel({
  id,
  channelId,
}: {
  id: string;
  channelId: any;
}) {
  const navigate = useNavigate();
  const user = useSelector((state: RootState) => state.user);

  const exitHandler = async () => {
    const response = await exitChannelAPI(user.id, channelId);
    console.log(response);
  };

  return (
    <Container id={id}>
      <Layer onClick={() => alert('todo: invite')}>Invite</Layer>
      <Layer onClick={() => alert('todo: Detail')}>Detail</Layer>
      <Layer onClick={exitHandler} color="red">
        Exit
      </Layer>
    </Container>
  );
}
