import React, { SetStateAction, useEffect, useRef } from 'react';
import SockJS from 'sockjs-client';
import { Stomp, CompatClient } from '@stomp/stompjs';

import { SendMessage, ChatMessage } from '../../types/chat.type';

const HOST = 'http://localhost:8083';

export default function chatSocketHook(
  channelId: string,
  setMsgList: React.Dispatch<SetStateAction<ChatMessage[]>>,
) {
  const stomp = useRef<CompatClient | null>(null);

  const connect = () => {
    const socket = new SockJS(HOST + '/chat');
    stomp.current = Stomp.over(socket);
    stomp.current.connect({}, subscribe);
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
    stomp.current?.send(HOST + 'pub/chat', {}, JSON.stringify(msg));
  };

  useEffect(() => {
    connect();
    console.log('useEffect - chat socket'); // remove
    return disconnect;
  }, [channelId]);

  return sendMessage;
}
