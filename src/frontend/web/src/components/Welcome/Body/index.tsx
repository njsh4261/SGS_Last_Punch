import React from 'react';
import styled from 'styled-components';
import WsList from './WsList';
import CreateWs from './CreateWsNav';

const SwelcomeBody = styled.main`
  margin: 0 64px 0 64px;
  flex: 1;

  & > * + * {
    margin-top: 48px;
  }
`;

export default function WelcomeBody() {
  return (
    <SwelcomeBody>
      <WsList></WsList>
      <CreateWs></CreateWs>
    </SwelcomeBody>
  );
}
