import React, { useState } from 'react';
import styled from 'styled-components';

import getWsHook from '../hook/getWs';
import updateChannelStoreHook from '../hook/updateChannelStore';
import setTitleHook from '../hook/setTitle';
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

  const [hover, setHover] = useState(false);
  const hoverHandler = () => setHover(!hover);

  const [sideToggle, setSideToggle] = useState(true);
  const sideToggleHandler = (e: React.MouseEvent<HTMLElement>) => {
    e.stopPropagation();
    setSideToggle(!sideToggle);
  };

  return (
    <MainLayout>
      <Body>
        <Aside
          ws={ws}
          hover={hover}
          hoverHandler={hoverHandler}
          sideToggle={sideToggle}
          sideToggleHandler={sideToggleHandler}
        ></Aside>
        {params.channelId ? (
          params.noteId ? (
            <NoteMain></NoteMain>
          ) : (
            <Chat
              sideToggle={sideToggle}
              sideToggleHandler={sideToggleHandler}
            ></Chat>
          )
        ) : (
          <GuideText>🍪 Select Channel 🍪</GuideText>
        )}
      </Body>
    </MainLayout>
  );
}
