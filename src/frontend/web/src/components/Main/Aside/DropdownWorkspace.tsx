import React from 'react';

import { useNavigate } from 'react-router-dom';
import { Container, Layer } from '../../Common/DropdownComponent';

export default function DropdownWorkspace({ id }: { id?: string }) {
  const navigate = useNavigate();
  return (
    <Container id={id} left={true}>
      <Layer onClick={() => alert('todo: invite')}>invite</Layer>
      <Layer onClick={() => alert('todo: exit workspace')} color="red">
        Exit
      </Layer>
    </Container>
  );
}
