import React, { SetStateAction, useEffect, useRef } from 'react';
import SockJS from 'sockjs-client';
import { Stomp, CompatClient } from '@stomp/stompjs';
import { TOKEN, URL } from '../constant';

import { SendMessage, ChatMessage } from '../../types/chat.type';

const HOST = 'http://localhost:8080';

export default function chatSocketHook(
  channelId: string,
  setMsgList: React.Dispatch<SetStateAction<ChatMessage[]>>,
) {
  const stomp = useRef<CompatClient | null>(null);

  const connect = () => {
    const accessToken = localStorage.getItem(TOKEN.ACCESS);
    if (!accessToken || !HOST) {
      console.error('fail connect socket - chat');
      return;
    }
    try {
      const socket = new SockJS(HOST + '/ws/chat');
      stomp.current = Stomp.over(socket);
      stomp.current.connect({ Authorization: accessToken }, subscribe);
    } catch (e) {
      console.error(e);
    }
  };

  const subscribe = () => {
    if (stomp.current === null) return;
    stomp.current.subscribe(HOST + `/topic/channel.${channelId}`, (payload) => {
      console.log(JSON.parse(payload.body));
      // setMesgList((msgList) => [...msgList, 'new' ])
    });
  };

  const disconnect = () => {
    if (stomp.current) stomp.current.disconnect();
  };

  const sendMessage = (msg: SendMessage) => {
    try {
      stomp.current?.send(HOST + '/app/chat', {}, JSON.stringify(msg));
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    connect();
    console.log('useEffect - chat socket'); // remove
    return disconnect;
  }, [channelId]);

  return sendMessage;
}
