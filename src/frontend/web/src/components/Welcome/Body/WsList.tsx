import React from 'react';
import styled from 'styled-components';
import expand from '../../../icon/expand.svg';
import WsItem from './WsItem';
import { IWorkspace } from '../../../../types/workspace.type';
import getWsListHook from '../../../hook/getWsList';

const Container = styled.section`
  border: 4px solid rgba(255, 255, 255, 0.2);
  border-radius: 9px;
`;

const Box = styled.article`
  display: flex;
  flex-direction: column;

  & > * {
    padding: 16px;
  }
`;

const BoxHeader = styled.article`
  background: ${({ theme }) => theme.color.snackHeader};
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
  font-size: 1.125rem;
`;

const BoxContent = styled.article`
  background: white;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
`;

const ShowMore = styled.article`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 54px;
  margin: -16px;
  margin-top: 34px;
`;

const ShowMoreButton = styled.button`
  color: #1264a3;
  font-size: 14px;
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
`;

const ShowMoreIcon = styled.div`
  &::after {
    display: block;
    content: '';
    height: 15px;
    width: 15px;
    background-image: url(${expand});
    background-repeat: no-repeat;
    margin-left: 4px;
  }
`;

export default function WsList() {
  const [wsList, getWsList] = getWsListHook();

  return (
    <Container>
      <Box>
        <BoxHeader>워크스페이스 목록</BoxHeader>
        <BoxContent>
          {wsList.map((ws: IWorkspace) => (
            <WsItem ws={ws} key={ws.id}></WsItem>
          ))}
          <ShowMore>
            <ShowMoreButton onClick={getWsList}>
              <span>더 보기</span>
              <ShowMoreIcon></ShowMoreIcon>
            </ShowMoreButton>
          </ShowMore>
        </BoxContent>
      </Box>
    </Container>
  );
}
