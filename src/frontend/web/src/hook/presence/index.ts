import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Stomp, CompatClient } from '@stomp/stompjs';
import SockJS from 'sockjs-client';

import { TOKEN, URL } from '../../constant';
import { UserStatus, UpdateMessage } from '../../../types/presence';
import { RootState } from '../../modules';
import { UserState } from '../../modules/user';
import { getPresenceAPI } from '../../Api/presence';
import { cloneDeep } from 'lodash';
import { setUserList } from '../../modules/userList';
import { setUser } from '../../modules/user';

interface Props {
  wsId: string | number;
  memberListRef: React.MutableRefObject<UserState[] | undefined>;
}

export default function presenceHook({ wsId, memberListRef }: Props) {
  const [stomp, setStomp] = useState<CompatClient | undefined>();
  // redux-store
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);

  const connect = () => {
    const accessToken = localStorage.getItem(TOKEN.ACCESS);
    if (!accessToken || !URL.HOST) {
      console.error('fail connect socket - presence');
      return;
    }

    try {
      const socket = new SockJS(URL.HOST + '/ws/presence');
      const stompClient = Stomp.over(socket);
      stompClient.debug = (f) => f;
      stompClient.connect({ Authorization: accessToken }, async () => {
        // status 업데이트
        stompClient.subscribe(`/topic/workspace.${wsId}`, (payload) => {
          const msg: UpdateMessage = JSON.parse(payload.body);
          // set status self
          if (+msg.userId === user.id) {
            dispatch(
              setUser({
                id: +user.id,
                name: user.name,
                status: msg.userStatus,
              }),
            );
          }
          // update user state (to memberListRef)
          const index = memberListRef.current!.findIndex(
            (member) => member.id === +msg.userId,
          );
          const newList = cloneDeep(memberListRef.current!);
          newList[index] = { ...newList[index], status: msg.userStatus };
          // bug: memberList에 status가 존재하지 않음 (ref)
          dispatch(setUserList(newList));
        });

        // 연결 메시지 전송
        sendMessage('CONNECT', stompClient);
        dispatch(setUser({ id: +user.id, name: user.name, status: 'ONLINE' }));
        // 첫 접속시 유저들의 프리젠스 상태 업데이트
        const presenceList: UpdateMessage[] = await getPresenceAPI(wsId);
        if (presenceList) {
          // userId: index in memberListRef.current!
          const userDictionary: { [index: string]: number } = {};
          memberListRef.current!.map(
            (member, index) => (userDictionary[member.id] = index),
          );
          const newList = cloneDeep(memberListRef.current!);
          presenceList.map((presence) => {
            // dictionray: presence.userId: userStatus
            const index = userDictionary[presence.userId];
            newList[index] = { ...newList[index], status: presence.userStatus };
          });
          dispatch(setUserList(newList));
        }
      });
      setStomp(stompClient);
    } catch (e) {
      console.error('socket Error in presence hook:', e);
    }
  };

  const disconnect = () => {
    if (stomp) {
      sendMessage('DISCONNECT');
      stomp.disconnect();
    }
  };

  const sendMessage = (userStatus: UserStatus, stompClient?: CompatClient) => {
    try {
      if (stomp) {
        stomp.send(
          '/app/update',
          {},
          JSON.stringify({
            workspaceId: wsId.toString(),
            userId: user.id.toString(),
            userStatus,
          }),
        );
      } else if (stompClient) {
        stompClient.send(
          '/app/update',
          {},
          JSON.stringify({
            workspaceId: wsId.toString(),
            userId: user.id.toString(),
            userStatus,
          }),
        );
      }
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    if (memberListRef.current!.length > 0) {
      connect();
    }
    return disconnect;
  }, []);

  return sendMessage;
}
