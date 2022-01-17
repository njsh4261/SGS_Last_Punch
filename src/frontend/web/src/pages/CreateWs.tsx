import React, { useState } from 'react';
import styled from 'styled-components';
import MainHeaderFrame from '../components/Common/MainHeaderFrame';
import MainAsideFrame from '../components/Common/MainAsideFrame';
import CreateWsContainer from '../components/CreateWs';
import { useNavigate } from 'react-router-dom';
import AsideHeader from '../components/Common/MainAsideHeader';

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
  const [wsName, setWsName] = useState('새 워크스페이스');
  const [channelName, setChannelName] = useState('');
  const [step, setStep] = useState(1);

  const navigate = useNavigate();

  const nextStepHandler = () => {
    if (step + 1 === 3) {
      if (channelName === '') {
        alert('팀이 사용할 채널 명을 입력하세요');
        return;
      }
      // alert('create workspace!');
      // call api (create workspace)
      // redirect this workspace
      navigate('/'); // 임시
      return;
    }
    setStep((state) => state + 1);
  };

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'ws') setWsName(e.target.value);
    if (e.target.name === 'channel') setChannelName(e.target.value);
  };

  return (
    <PageLayout>
      <MainHeaderFrame></MainHeaderFrame>
      <Body>
        <MainAsideFrame>
          <AsideHeader>{wsName}</AsideHeader>
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
