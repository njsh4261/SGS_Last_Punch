import React from 'react';
import styled from 'styled-components';

import { UserStatus } from '../../../types/presence';

const Container = styled.div`
  width: 10px;
  height: 10px;
  background-color: white;
  position: relative;
  right: 14px;
  top: 10px;
`;

const Circle = styled.div<{ color: string }>`
  width: 10px;
  height: 10px;
  border-radius: 10px;
  background-color: ${({ color }) => color};
  border: 1px solid lightgray;
`;

interface Props {
  status: UserStatus;
}

export default function StatusCircle({ status }: Props) {
  return (
    <Container>
      <Circle
        color={
          status === 'ONLINE'
            ? 'green'
            : status === 'BUSY'
            ? 'yellow'
            : status === 'ABSENT'
            ? 'red'
            : 'gray'
        }
      ></Circle>
    </Container>
  );
}