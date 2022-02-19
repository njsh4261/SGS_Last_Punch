import { useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Stomp, CompatClient, IMessage } from '@stomp/stompjs';
import SockJS from 'sockjs-client';

import { TOKEN, URL } from '../../constant';
import { UserStatus, UpdateMessage } from '../../../types/presence';
import { RootState } from '../../modules';
import { getPresenceAPI } from '../../Api/presence';
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
        // workspace내의 status 업데이트에 대한 구독
        stompClient.subscribe(`/topic/workspace.${wsId}`, updateStatus);
        // 첫 연결 시 유저들의 프리젠스 상태 업데이트
        getPresenceList();
        // 연결 메시지 전송
        sendMessage('CONNECT', stompClient);
      });
      setStomp(stompClient);
    } catch (e) {
      console.error('socket Error in presence hook:', e);
    }
  };

  // subscribe의 callback함수. status 관련 메시지가 오면 presence store에 업데이트
  const updateStatus = (payload: IMessage) => {
    const msg: UpdateMessage = JSON.parse(payload.body);

    if (presenceRef.current) {
      // 현재 presence store에 없는 유저. connect가 오면 online으로 업데이트.
      if (!presenceRef.current[msg.userId]) {
        if (msg.userStatus === 'CONNECT') {
          dispatcher(msg.userId, 'ONLINE');
        } else {
          // 예외 상황
          dispatcher(msg.userId, msg.userStatus);
        }
        // 현재 presence store에 있는 유저인데 CONNECT 메시지가 오면 업데이트 하지 않음(동시접속 처리)
      } else {
        if (msg.userStatus !== 'CONNECT') {
          dispatcher(msg.userId, msg.userStatus);
        } else {
          // ignore
        }
      }
    }
  };

  const dispatcher = (userId: string, userStatus: UserStatus) => {
    dispatch(
      setPresence({
        ...presenceRef.current,
        [userId]: userStatus,
      }),
    );
  };

  const disconnect = () => {
    if (stomp) {
      sendMessage('DISCONNECT');
      stomp.disconnect();
    }
  };

  const getPresenceList = async () => {
    const presenceList: UpdateMessage[] = await getPresenceAPI(wsId);
    if (presenceList) {
      // presence의 data structure
      const dictionary: { [index: string]: UserStatus } = {};
      presenceList.map((presence) => {
        dictionary[presence.userId] = presence.userStatus;
      });
      dispatch(setPresence(dictionary));
    } else {
      console.error('fail get presence');
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
