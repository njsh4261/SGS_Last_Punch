import React, { useState } from 'react';
import styled from 'styled-components';
import MainHeaderFrame from '../components/Common/MainHeaderFrame';
import MainAsideFrame from '../components/Common/MainAsideFrame';
import Chat from '../components/Main/Chat';

const PageLayout = styled.div`
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const Body = styled.div`
  display: flex;
  height: 100%;
`;

const MainAsideWsName = styled.div`
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: 260px;
  min-height: 49px;
  background-color: rgb(82, 38, 83);
  color: white;
  font-size: 19px;
  font-weight: 500;
  font-family: NotoSansKR, Slack-Lato, appleLogo, sans-serif;
  padding: 12.5px 16px 12.5px;
`;

export default function WsCreator() {
  const [wsName, setWsName] = useState('새 워크스페이스');
  return (
    <PageLayout>
      <MainHeaderFrame></MainHeaderFrame>
      <Body>
        <MainAsideFrame>
          <MainAsideWsName>{wsName}ascalksncjacnajkcacssasdasa</MainAsideWsName>
        </MainAsideFrame>
        <Chat></Chat>
      </Body>
    </PageLayout>
  );
}
