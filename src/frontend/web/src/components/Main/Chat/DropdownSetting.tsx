import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';

import logout from '../../../util/logout';
import { Container, Layer } from '../../Common/DropdownComponent';
import { openModal } from '../../../modules/modal';

export default function Dropdown({ id }: { id: string }) {
  const navigate = useNavigate();
  const dispatch = useDispatch();

  return (
    <Container id={id}>
      <Layer onClick={() => navigate('/')}>Home</Layer>
      <Layer onClick={() => dispatch(openModal('profile'))}>Profile</Layer>
      <Layer onClick={() => logout()} color="red">
        Logout
      </Layer>
    </Container>
  );
}
