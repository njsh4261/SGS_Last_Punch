import React from 'react';
import styled from 'styled-components';

import getSelfInfoHook from '../hook/getSelfInfo';
import setTitleHook from '../hook/setTitle';
import WelcomeHeader from '../components/Welcome/Header';
import WelcomeBody from '../components/Welcome/Body';

const WelcomePage = styled.div`
  background-color: ${(props) => props.theme.color.snackSide};
  height: 100%;
  overflow-y: scroll;
`;

const Layout = styled.div`
  display: flex;
  flex-direction: column;
  max-width: 650px;
  margin: 0 auto;
`;

export default function Welcome() {
  setTitleHook('Welcome');
  getSelfInfoHook();

  return (
    <WelcomePage>
      <Layout>
        <WelcomeHeader></WelcomeHeader>
        <WelcomeBody></WelcomeBody>
      </Layout>
    </WelcomePage>
  );
}
