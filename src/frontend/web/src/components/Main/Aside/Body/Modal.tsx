import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { useParams } from 'react-router-dom';
import { closeModal } from '../../../../modules/modal';
import styled from 'styled-components';
import { createChannelAPI } from '../../../../Api/channel';

const Container = styled.article`
  position: absolute;
  z-index: 1;
  width: 520px;
  background-color: white;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  border-radius: 8px;
  box-shadow: 0 18px 48px 0 rgba(0, 0, 0, 0.35);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  font-family: NotoSansKR, Slack-Lato, appleLogo, sans-serif;
  font-size: 15px;
  color: black;
  letter-spacing: 0.5px;
`;

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
  ${Label} + ${Input} {
    margin-top: 10px;
  }
`;

const Explain = styled.section`
  opacity: 50%;
  margin-bottom: 26px;
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

export default function Modal() {
  const dispatch = useDispatch();
  const params = useParams();
  const [channelName, setChannelName] = useState('');
  const [description, setDescription] = useState('');

  const inputHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.name === 'channelName') setChannelName(e.target.value);
    if (e.target.name === 'description') setDescription(e.target.value);
  };

  const submitHandler = async () => {
    if (channelName === '') return;
    const success = await createChannelAPI({
      workspaceId: Number(params.wsId),
      name: channelName,
      description,
    });
    if (success) {
      dispatch(closeModal());
      window.location.reload(); // todo: 다른 방식으로 갱신
    } else {
      alert('채널 생성 실패');
      dispatch(closeModal());
    }
  };

  return (
    <Container>
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
    </Container>
  );
}
