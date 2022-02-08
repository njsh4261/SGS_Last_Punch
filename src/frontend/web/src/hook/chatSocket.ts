import React, { SetStateAction, useEffect, useRef } from 'react';
import SockJS from 'sockjs-client';
import { Stomp, CompatClient } from '@stomp/stompjs';
import { TOKEN, URL } from '../constant';

import { SendMessage, ChatMessage } from '../../types/chat.type';

const HOST = URL.HOST;

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
      const stompClient = Stomp.over(socket);
      stompClient.connect({ Authorization: accessToken }, () => {
        stompClient.subscribe(`/topic/channel.${channelId}`, (payload) => {
          const msg = JSON.parse(payload.body);
          setMsgList((msgList: ChatMessage[]) => [...msgList, msg]);
        });
      });
      stomp.current = stompClient;
    } catch (e) {
      console.error('socket Error:', e);
    }
  };

  const disconnect = () => {
    if (stomp.current) stomp.current.disconnect();
  };

  const sendMessage = (msg: SendMessage) => {
    try {
      if (stomp.current)
        stomp.current.send('/app/chat', {}, JSON.stringify(msg));
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    connect();
    return disconnect;
  }, []);

  return sendMessage;
}
