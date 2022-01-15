import React from 'react';
import styled from 'styled-components';
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
  return (
    <MainLayout>
      <MainHeader></MainHeader>
      <Body>
        <Aside></Aside>
        <Chat></Chat>
      </Body>
    </MainLayout>
  );
}
