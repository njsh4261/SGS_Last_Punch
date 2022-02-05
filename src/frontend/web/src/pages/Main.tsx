import React from 'react';
import styled from 'styled-components';

import getWsHook from '../hook/getWs';
import updateChannelStoreHook from '../hook/updateChannelStore';
import setTitleHook from '../hook/setTitle';
import MainHeader from '../components/Main/Header';
import Chat from '../components/Main/Chat';
import NoteMain from '../components/Note/Main';
import Aside from '../components/Main/Aside';

const MainLayout = styled.div`
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const Body = styled.div`
  display: flex;
  height: 100%;
`;

const GuideText = styled.div`
  margin: auto;
  font-size: 30px;
  font-weight: bold;
`;

export default function Main() {
  const [params, ws] = getWsHook();
  setTitleHook('', params);
  updateChannelStoreHook(params);

  return (
    <MainLayout>
      <MainHeader></MainHeader>
      <Body>
        <Aside ws={ws}></Aside>
        {params.channelId ? (
          params.noteId ? (
            <NoteMain></NoteMain>
          ) : (
            <Chat></Chat>
          )
        ) : (
          <GuideText>🍪 Select Channel 🍪</GuideText>
        )}
      </Body>
    </MainLayout>
  );
}
