import React, { useState } from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import getWsHook from '../hook/getWs';
import updateChannelStoreHook from '../hook/updateChannelStore';
import Chat from '../components/Main/Chat';
import NoteMain from '../components/Main/Note';
import Aside from '../components/Main/Aside';
import { RootState } from '../modules';
import Loading from '../components/Common/Loading';
import getSelfInfoHook from '../hook/getSelfInfo';
import alarmOffHook from '../hook/alarmOff';

const MainLayout = styled.div`
  display: flex;
  height: 100%;
`;

export default function Main() {
  const [params, ws] = getWsHook();
  const channelList = useSelector((state: RootState) => state.channelList);
  const memberList = useSelector((state: RootState) => state.userList);
  const user = useSelector((state: RootState) => state.user);
  const [hover, setHover] = useState(false);
  const [sideToggle, setSideToggle] = useState(true);

  // hover시 사이드바를 감추는 버튼 노출
  const hoverHandler = () => setHover(!hover);
  // 사이드바 토글로 감추거나 노출시킴
  const sideToggleHandler = (e: React.MouseEvent<HTMLElement>) => {
    e.stopPropagation();
    setSideToggle(!sideToggle);
  };

  // API로 사용자 정보를 가져오고 store에 저장
  getSelfInfoHook();
  // url 변경시 파라미터의 채널 id와 그 name을 store에 저장
  updateChannelStoreHook(params, memberList);
  // 알림이 표시된 채널에 진입시 알림 해제
  alarmOffHook({ params, memberList, channelList });

  return (
    <MainLayout>
      <Aside
        ws={ws}
        hover={hover}
        hoverHandler={hoverHandler}
        sideToggle={sideToggle}
        sideToggleHandler={sideToggleHandler}
      ></Aside>
      {channelList.length > 0 &&
      memberList.length > 0 &&
      params.channelId &&
      user.id !== 0 ? (
        params.noteId ? (
          <NoteMain
            sideToggle={sideToggle}
            sideToggleHandler={sideToggleHandler}
          ></NoteMain>
        ) : (
          <Chat
            sideToggle={sideToggle}
            sideToggleHandler={sideToggleHandler}
          ></Chat>
        )
      ) : (
        <Loading></Loading>
      )}
    </MainLayout>
  );
}
