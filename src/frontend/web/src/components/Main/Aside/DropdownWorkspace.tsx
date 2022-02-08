import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';

import { Container, Layer } from '../../Common/DropdownComponent';
import { exitWsAPI } from '../../../Api/workspace';
import { RootState } from '../../../modules';

export default function DropdownWorkspace({ wsId }: { wsId: number }) {
  const navigate = useNavigate();
  const user = useSelector((state: RootState) => state.user);

  const inviteHandler = async () => {
    alert('open modal, search, invtie');
  };

  const exitHandler = async () => {
    const response = await exitWsAPI(wsId, user.id);
    console.log('res:', response);
  };

  return (
    <Container left={true}>
      <Layer onClick={inviteHandler}>Invite</Layer>
      <Layer onClick={() => alert('todo: Detail')}>Detail</Layer>
      <Layer onClick={exitHandler} color="red">
        Exit
      </Layer>
    </Container>
  );
}
