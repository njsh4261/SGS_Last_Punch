import React from 'react';
import { useSelector, useDispatch } from 'react-redux';

import { Container, Layer } from '../../Common/DropdownComponent';
import { exitWsAPI } from '../../../Api/workspace';
import { RootState } from '../../../modules';
import { openModal } from '../../../modules/modal';
import { getWsMemberAPI } from '../../../Api/workspace';

export default function DropdownWorkspace({ wsId }: { wsId: number }) {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);

  const inviteHandler = async () => {
    dispatch(openModal('invite-workspace'));
  };

  const exitHandler = async () => {
    const response = await exitWsAPI(wsId, user.id);
    console.log('res:', response);
  };

  const getMemberHandler = async () => {
    const response = await getWsMemberAPI(wsId);
    if (response?.members) {
      const workspaceMembers = response.members.content;
      console.log({ workspaceMembers });
      // todo: render 'worskapceMembers'
    }
  };

  return (
    <Container left={true}>
      <Layer onClick={inviteHandler}>Invite</Layer>
      <Layer onClick={getMemberHandler}>Member</Layer>
      <Layer onClick={() => alert('todo: Detail')}>Detail</Layer>
      <Layer onClick={exitHandler} color="red">
        Exit
      </Layer>
    </Container>
  );
}
