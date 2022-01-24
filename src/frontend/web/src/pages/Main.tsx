import React from 'react';
import styled from 'styled-components';

import getWsHook from '../hook/getWs';
import updateChannelStoreHook from '../hook/updateChannelStore';
import setTitleHook from '../hook/setTitle';
import MainHeader from '../components/Main/Header';
import Chat from '../components/Main/Chat';
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

export default function Main() {
  const [params, wsName] = getWsHook();
  setTitleHook('', params);
  updateChannelStoreHook(params);

  return (
    <MainLayout>
      <MainHeader wsName={wsName}></MainHeader>
      <Body>
        <Aside wsName={wsName}></Aside>
        {params.channelId ? (
          <Chat></Chat>
        ) : (
          <div>this is main page. select channel!</div>
        )}
      </Body>
    </MainLayout>
  );
}
