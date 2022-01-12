import React from 'react';
import styled from 'styled-components';
import WelcomeHeader from '../components/Welcome/Header';
import WelcomeBody from '../components/Welcome/Body';

const WelcomePage = styled.div`
  background-color: ${(props) => props.theme.color.slack};
  height: 100%;
  display: flex;
  flex-direction: column;
`;

export default function Welcome() {
  return (
    <WelcomePage>
      <WelcomeHeader></WelcomeHeader>
      <WelcomeBody></WelcomeBody>
    </WelcomePage>
  );
}
