import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import styled from 'styled-components';
import { useParams } from 'react-router-dom';
import MainHeader from '../components/Main/Header';
import Chat from '../components/Main/Chat';
import Aside from '../components/Main/Aside';
import { selectWork } from '../modules/worksapce';

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
  const params = useParams();
  const dispatch = useDispatch();

  const getWsInfo = async () => {
    const workspaceId = Number(params.wsId);
    dispatch(selectWork(workspaceId));
  };

  useEffect(() => {
    getWsInfo();
  }, []);

  useEffect(() => {
    if (!params.channelId) document.title = params.wsId as string;
  }, [params]);

  return (
    <MainLayout>
      <MainHeader></MainHeader>
      <Body>
        <Aside></Aside>
        {params.channelId ? (
          <Chat params={params}></Chat>
        ) : (
          <div>this is main page. select channel!</div>
        )}
      </Body>
    </MainLayout>
  );
}
