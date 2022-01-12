import React from 'react';
import styled from 'styled-components';
import CreateWs from './CreateWs';

const SwelcomeBody = styled.main`
  margin: 0 64px 0 64px;
  flex: 1;
`;

export default function WelcomeBody() {
  return (
    <SwelcomeBody>
      <CreateWs></CreateWs>
    </SwelcomeBody>
  );
}
