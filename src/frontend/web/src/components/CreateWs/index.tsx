import React from 'react';
import styled from 'styled-components';
import StepCounter from './StepCounter';
import SubmitButton from '../Common/SubmitButton';

const Container = styled.main`
  padding: 32px 80px 64px;
  height: 100%;
  width: 820px;
  display: flex;
  flex-direction: column;
  font-family: NotoSansKR, Slack-Lato, appleLogo, sans-serif;
`;

const Question = styled.h2`
  margin-bottom: 12px;
  font-size: 50px;
  margin-top: 0;
  font-weight: 600;
`;

const Explanation = styled.section`
  margin-bottom: 24px;
  font-weight: 300;
  font-size: 16px;
`;

const Input = styled.input`
  height: 44px;
  font-size: 18px;
  line-height: 1.3333333;
  padding: 11px 46px 13px 12px;
  border: 1px solid ${({ theme }) => theme.color.lightGrey};
  border-radius: 4px;
`;

const ButtonBox = styled.section`
  width: 200px;
  margin-top: 48px;
`;

interface Props {
  step: number;
  wsName: string;
  channelName: string;
  nextStepHandler: () => void;
  inputHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
}

export default function CreateWsContainer({
  step,
  nextStepHandler,
  wsName,
  channelName,
  inputHandler,
}: Props) {
  const questions = [
    '',
    '회사 또는 팀 이름이 어떻게 됩니까?',
    '현재 고객님의 팀은 어떤 일을 진행하고 계시나요?',
  ];
  const explanation = [
    '',
    'Slack 워크스페이스의 이름이 됩니다. 팀이 인식할 수 있는 이름을 입력하세요.',
    '프로젝트, 캠페인, 이벤트 또는 성사하려는 거래 등 무엇이든 될 수 있습니다.',
  ];

  return (
    <Container>
      <StepCounter>
        {step}/{questions.length - 1} 단계
      </StepCounter>
      <Question>{questions[step]}</Question>
      <Explanation>{explanation[step]}</Explanation>
      {step === 1 ? (
        <Input
          autoComplete="off"
          name="ws"
          value={wsName}
          onChange={inputHandler}
        />
      ) : (
        <Input
          autoComplete="off"
          name="channel"
          placeholder="예: 수다방, 공지사항"
          value={channelName}
          onChange={inputHandler}
        />
      )}

      <ButtonBox>
        <SubmitButton
          text="다음"
          borderRadius="4px"
          submitHandler={nextStepHandler}
        />
      </ButtonBox>
    </Container>
  );
}
