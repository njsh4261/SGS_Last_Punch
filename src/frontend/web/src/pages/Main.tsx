import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { useDispatch, useSelector } from 'react-redux';
import cloneDeep from 'lodash/cloneDeep';

import getWsHook from '../hook/getWs';
import updateChannelStoreHook from '../hook/updateChannelStore';
import Chat from '../components/Main/Chat';
import NoteMain from '../components/Main/Note';
import Aside from '../components/Main/Aside';
import { RootState } from '../modules';
import Loading from '../components/Common/Loading';
import { setChannelListRedux } from '../modules/channeList';
import getSelfInfoHook from '../hook/getSelfInfo';
import { setUserList } from '../modules/userList';

const MainLayout = styled.div`
  display: flex;
  height: 100%;
`;

export default function Main() {
  const dispatch = useDispatch();
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
  useEffect(() => {
    if (params.channelId?.split('-')) {
      // members
      const [low, high] = params.channelId.split('-');
      const targetId = user.id === +low ? high : low;
      const index = memberList.findIndex((el) => el.id.toString() === targetId);
      const newList = cloneDeep(memberList);
      if (newList[index]?.alarm) {
        newList[index] = { ...newList[index], alarm: false };
        dispatch(setUserList(newList));
      }
    } else {
      // channels
      const index = channelList.findIndex(
        (el) => el.id.toString() === params.channelId,
      );
      const newList = cloneDeep(channelList);
      if (newList[index]?.alarm) {
        newList[index] = { ...newList[index], alarm: false };
        dispatch(setChannelListRedux(newList));
      }
    }
  }, [params]);

  return (
    <MainLayout>
      <Aside
        ws={ws}
        hover={hover}
        hoverHandler={hoverHandler}
        sideToggle={sideToggle}
        sideToggleHandler={sideToggleHandler}
      ></Aside>
      {channelList.length > 0 && memberList.length > 0 && params.channelId ? (
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
