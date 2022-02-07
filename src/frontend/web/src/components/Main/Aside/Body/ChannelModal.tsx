import React from 'react';
import styled from 'styled-components';
import createChannelHook from '../../../../hook/createChannel';

const Header = styled.section`
  width: 100%;
  padding: 28px 76px 20px 28px;
`;

const HeaderH1 = styled.h1`
  font-size: 28px;
  margin: 0;
`;

const Body = styled.section`
  flex: 1;
  width: 100%;
`;

const BodyLayout = styled.div`
  padding: 0 28px;
`;

const Label = styled.label`
  font-weight: 700;
  padding-right: 10px;
`;

const Input = styled.input`
  width: 100%;
  border: 1px solid lightgray;
  border-radius: 4px;
  font-size: 17px;
  padding: 12px;
`;

const InputLayer = styled.article`
  margin-bottom: 20px;
  display: flex;
  align-items: center;
`;

const Explain = styled.section`
  opacity: 50%;
  margin-bottom: 26px;
  overflow: hidden;
  white-space: normal;
`;

const Footer = styled.section`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: end;
  padding-right: 28px;
  margin-bottom: 28px;
`;

const Button = styled.button<{ active: boolean }>`
  border: none;
  border-radius: 4px;
  outline: none;
  cursor: ${(props) => (props.active ? 'pointer' : 'not-allowed')};
  background-color: ${(props) => (props.active ? '#007A5A' : '#DDDDDD')};
  width: 56px;
  height: 35px;
  padding: 0 12px 1px;
  color: white;
`;
export default function ChannelModal() {
  const [channelName, description, inputHandler, submitHandler] =
    createChannelHook();

  return (
    <>
      <Header>
        <HeaderH1>채널 생성</HeaderH1>
      </Header>
      <Body>
        <BodyLayout>
          <Explain>
            채널은 팀이 소통하는 공간입니다. 채널은 주제(예: 마케팅)를 중심으로
            구성하는 것이 가장 좋습니다.
          </Explain>
          <InputLayer>
            <Label>이름</Label>
            <Input
              name="channelName"
              placeholder="# 예: 라스트 펀치"
              value={channelName}
              onChange={inputHandler}
            ></Input>
          </InputLayer>
          <InputLayer>
            <Label>설명</Label>
            <Input
              name="description"
              placeholder="무엇에 대한 설명인가요?"
              value={description}
              onChange={inputHandler}
            ></Input>
          </InputLayer>
        </BodyLayout>
      </Body>
      <Footer>
        <Button active={channelName !== ''} onClick={submitHandler}>
          생성
        </Button>
      </Footer>
    </>
  );
}
