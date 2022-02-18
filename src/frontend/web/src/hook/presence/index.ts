import { useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Stomp, CompatClient } from '@stomp/stompjs';
import SockJS from 'sockjs-client';

import { TOKEN, URL } from '../../constant';
import { UserStatus, UpdateMessage } from '../../../types/presence';
import { RootState } from '../../modules';
import { getPresenceAPI } from '../../Api/presence';
import { setUser } from '../../modules/user';
import { setPresence } from '../../modules/presence';

interface Props {
  wsId: string | number;
}

export default function presenceHook({ wsId }: Props) {
  const [stomp, setStomp] = useState<CompatClient | undefined>();
  // redux-store
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const presence = useSelector((state: RootState) => state.presence);
  const presenceRef = useRef<RootState['presence']>();

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
          // update presence store
          dispatch(
            setPresence({
              ...presenceRef.current,
              [msg.userId]: msg.userStatus,
            }),
          );
        });

        // 연결 메시지 전송
        sendMessage('CONNECT', stompClient);

        // user module의 status online으로 업데이트
        dispatch(setUser({ id: +user.id, name: user.name, status: 'ONLINE' }));

        // 첫 접속시 유저들의 프리젠스 상태 업데이트
        const presenceList: UpdateMessage[] = await getPresenceAPI(wsId);
        if (presenceList) {
          // presence의 data structure
          const dictionary: { [index: string]: UserStatus } = {};
          presenceList.map((presence) => {
            dictionary[presence.userId] = presence.userStatus;
          });
          dispatch(setPresence(dictionary));
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
    presenceRef.current = presence;
  }, [presence]);

  useEffect(() => {
    connect();
    return disconnect;
  }, []);

  return sendMessage;
}
