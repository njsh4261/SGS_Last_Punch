import React from 'react';

import clearSession from '../../../util/clearSession';
import { useNavigate } from 'react-router-dom';
import { Container, Layer } from '../../Common/DropdownComponent';

export default function DropdownChannel({ id }: { id: string }) {
  const navigate = useNavigate();
  return (
    <Container id={id}>
      <Layer onClick={() => alert('todo: invite')}>invite</Layer>
      <Layer onClick={() => alert('todo: exit channel')} color="red">
        Exit
      </Layer>
    </Container>
  );
}
