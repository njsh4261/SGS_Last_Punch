import React from 'react';
import styled from 'styled-components';

import clearSession from '../../../util/clearSession';
import { useNavigate } from 'react-router-dom';

const Container = styled.div`
  position: absolute;
  z-index: 1;
  top: 0;
  right: 0;
  transform: translateY(50%);
  width: 100px;
  border: 1px solid darkgray;
  border-radius: 8px;
  box-shadow: 0 8px 14px rgba(0, 0, 0, 0.35);
  overflow: hidden;
`;

const Layer = styled.article<{ color?: string }>`
  border-bottom: 1px solid lightgray;
  text-align: center;
  padding: 4px 0;
  color: ${({ color }) => color};
  :hover {
    cursor: pointer;
    background-color: lightgray;
  }
`;

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
