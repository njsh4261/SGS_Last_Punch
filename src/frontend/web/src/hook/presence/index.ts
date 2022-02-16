import { useEffect, useState } from 'react';
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

interface Props {
  wsId: string | number;
  memberList: UserState[];
}

export default function presenceHook({ wsId, memberList }: Props) {
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
      // stompClient.debug= (f) => f;
      stompClient.connect({ Authorization: accessToken }, async () => {
        stompClient.subscribe(`topic/workspace.${wsId}`, (payload) => {
          const msg: UpdateMessage = JSON.parse(payload.body);
          // update user state (to memberList)
          const index = memberList.findIndex(
            (member) => member.id === +msg.userId,
          );
          const newList = cloneDeep(memberList);
          newList[index] = { ...newList[index], status: msg.userStatus };
          dispatch(setUserList(newList));
        });
        sendMessage('ONLINE');
        // todo: update memberList
        const response = await getPresenceAPI(wsId);
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

  const sendMessage = (userStatus: UserStatus) => {
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
      }
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    connect();
    return disconnect;
  }, []);
}
