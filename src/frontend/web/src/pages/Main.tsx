import React from 'react';
import styled from 'styled-components';
import MainHeader from '../components/Main/Header';
import Chat from '../components/Main/Chat';
import Note from './Note';
import Aside from '../components/Main/Aside';
import { useParams } from 'react-router-dom';

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
  // useParams: { wsId: string; channelId: string; noteId?: string}
  // useEffect(): get workspace, member, channel Info.
  const params = useParams();

  return (
    <MainLayout>
      <MainHeader></MainHeader>
      <Body>
        <Aside></Aside>
        {params.noteId ? <Note></Note> : <Chat></Chat>}
      </Body>
    </MainLayout>
  );
}
