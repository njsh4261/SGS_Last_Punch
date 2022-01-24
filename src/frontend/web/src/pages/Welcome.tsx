import React from 'react';
import styled from 'styled-components';
import setTitleHook from '../hook/setTitle';
import WelcomeHeader from '../components/Welcome/Header';
import WelcomeBody from '../components/Welcome/Body';

const WelcomePage = styled.div`
  background-color: ${(props) => props.theme.color.slack};
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow-y: scroll;
`;

export default function Welcome() {
  setTitleHook('Welcome');

  return (
    <WelcomePage>
      <WelcomeHeader></WelcomeHeader>
      <WelcomeBody></WelcomeBody>
    </WelcomePage>
  );
}
