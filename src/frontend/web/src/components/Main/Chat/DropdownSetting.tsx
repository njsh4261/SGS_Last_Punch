import React from 'react';

import logout from '../../../util/logout';
import { useNavigate } from 'react-router-dom';
import { Container, Layer } from '../../Common/DropdownComponent';

export default function Dropdown({ id }: { id: string }) {
  const navigate = useNavigate();
  return (
    <Container id={id}>
      <Layer onClick={() => navigate('/')}>Home</Layer>
      <Layer onClick={() => alert('todo: profile')}>Profile</Layer>
      <Layer onClick={() => logout()} color="red">
        Logout
      </Layer>
    </Container>
  );
}
