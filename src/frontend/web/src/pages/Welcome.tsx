import React from 'react';
import styled from 'styled-components';

import getSelfInfoHook from '../hook/getSelfInfo';
import setTitleHook from '../hook/setTitle';
import WelcomeHeader from '../components/Welcome/Header';
import WelcomeBody from '../components/Welcome/Body';

const WelcomePage = styled.div`
  background-color: ${(props) => props.theme.color.snackSide};
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow-y: scroll;
`;

export default function Welcome() {
  setTitleHook('Welcome');
  getSelfInfoHook();

  return (
    <WelcomePage>
      <WelcomeHeader></WelcomeHeader>
      <WelcomeBody></WelcomeBody>
    </WelcomePage>
  );
}
