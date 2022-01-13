import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';

const Container = styled.section`
  border: 4px solid rgba(255, 255, 255, 0.2);
  border-radius: 9px;
`;

const Box = styled.article`
  background-color: white;
  display: flex;
  flex-direction: column;
  padding: 16px;
  border-radius: 5px;
`;

const GuideText = styled.p`
  font-size: 16px;
  font-weight: 700;
`;

const CreateWsButton = styled.button`
  appearance: none;
  background: 0 0;
  border: 1px solid grey;
  border-radius: 4px;
  text-align: center;
  width: 100%;
  font-weight: 600;
  font-size: 16px;
  color: ${(props) => props.theme.color.slack};
  height: 50.5px;

  &:hover {
    cursor: pointer;
    border: 2px solid black;
  }
`;

const Image = styled.img`
  margin: 16px -16px -47px -16px;
`;

export default function CreateWs() {
  const navigate = useNavigate();
  const createWsHandler = () => {
    navigate('/create-workspace');
  };
  return (
    <Container>
      <Box>
        <GuideText>다른 팀과 Snack을 사용하고 싶으세요?</GuideText>
        <CreateWsButton onClick={createWsHandler}>
          새 워크스페이스 개설
        </CreateWsButton>
        <Image
          src="https://a.slack-edge.com/613463e/marketing/img/homepage/bold-existing-users/create-new-workspace-module/woman-with-laptop-color-background.png"
          height="121"
          width="200"
        />
      </Box>
    </Container>
  );
}
