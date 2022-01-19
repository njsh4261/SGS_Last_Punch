import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import styled from 'styled-components';
import { useParams, useNavigate } from 'react-router-dom';
import MainHeader from '../components/Main/Header';
import Chat from '../components/Main/Chat';
import Aside from '../components/Main/Aside';
import { getWsInfoAPI } from '../Api/workspace';
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
  // useParams: { wsId: string; channelId?: string; noteId?: string}
  const params = useParams();
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const getWsInfo = async () => {
    const workspaceId = Number(params.wsId);
    const { workspace } = await getWsInfoAPI(workspaceId);

    dispatch(selectWork(workspace.id, workspace.name, navigate));
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
          <Chat></Chat>
        ) : (
          <div>this is main page. select channel!</div>
        )}
      </Body>
    </MainLayout>
  );
}
