import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import MainHeaderFrame from '../components/Common/MainHeaderFrame';
import MainAsideFrame from '../components/Common/MainAsideFrame';
import CreateWsContainer from '../components/CreateWs';
import AsideHeader from '../components/Common/MainAsideHeader';
import { createWsAPI } from '../Api/workspace';

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

  const nextStepHandler = async () => {
    if (step + 1 === 3) {
      if (channelName === '') {
        alert('팀이 사용할 채널 명을 입력하세요');
        return;
      }
      const response = await createWsAPI(wsName, channelName);
      // todo: 응답코드에 따른 올바른 처리
      if (!response) {
        alert('fail');
        navigate('/');
      } else {
        alert('success');
        navigate('/');
      }
      return;
    }
    setStep((state) => state + 1);
  };

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'ws') setWsName(e.target.value);
    if (e.target.name === 'channel') setChannelName(e.target.value);
  };

  useEffect(() => {
    document.title = 'create snack!';
  }, []);

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
