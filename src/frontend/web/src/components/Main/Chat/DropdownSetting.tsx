import React from 'react';

import clearSession from '../../../util/clearSession';
import { useNavigate } from 'react-router-dom';
import { Container, Layer } from '../../Common/DropdownComponent';

export default function Dropdown({ id }: { id: string }) {
  const navigate = useNavigate();
  return (
    <Container id={id}>
      <Layer onClick={() => navigate('/')}>Home</Layer>
      <Layer onClick={() => alert('todo: profile')}>Profile</Layer>
      <Layer onClick={() => clearSession()} color="red">
        Logout
      </Layer>
    </Container>
  );
}
