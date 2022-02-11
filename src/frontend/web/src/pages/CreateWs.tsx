import React from 'react';
import styled from 'styled-components';

import setTitleHook from '../hook/setTitle';
import createWsHook from '../hook/createWs';
import MainHeaderFrame from '../components/Common/MainHeaderFrame';
import MainAsideFrame from '../components/Common/MainAsideFrame';
import CreateWsContainer from '../components/CreateWs';
import AsideHeader from '../components/Common/MainAsideHeader';
import { WorkspaceName } from '../components/Common/WorkspaceName';

const PageLayout = styled.div`
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const Body = styled.div`
  display: flex;
  height: 100%;
`;

export default function WsCreator() {
  const [wsName, channelName, inputHandler, step, nextStepHandler] =
    createWsHook();
  setTitleHook('create snack!');

  return (
    <PageLayout>
      <MainHeaderFrame></MainHeaderFrame>
      <Body>
        <MainAsideFrame toggle={true}>
          <AsideHeader>
            <WorkspaceName>{wsName}</WorkspaceName>
          </AsideHeader>
        </MainAsideFrame>
        <CreateWsContainer
          step={step}
          wsName={wsName}
          channelName={channelName}
          inputHandler={inputHandler}
          nextStepHandler={nextStepHandler}
        ></CreateWsContainer>
      </Body>
    </PageLayout>
  );
}
