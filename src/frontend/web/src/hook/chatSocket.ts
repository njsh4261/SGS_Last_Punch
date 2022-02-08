import React, { SetStateAction, useEffect, useRef } from 'react';
import SockJS from 'sockjs-client';
import { Stomp, CompatClient } from '@stomp/stompjs';
import { TOKEN, URL } from '../constant';
import { useDispatch } from 'react-redux';

import { SendMessage, ChatMessage } from '../../types/chat.type';
import { setChannelListRedux } from '../modules/channeList';

const HOST = URL.HOST;

export default function chatSocketHook(
  channelId: string,
  setMsgList: React.Dispatch<SetStateAction<ChatMessage[]>>,
  channelList: any[],
) {
  const channelRef = useRef(channelId);
  const dispatch = useDispatch();
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
        if (channelList.length < 1) return;

        channelList.map((channel) => {
          stompClient.subscribe(`/topic/channel.${channel.id}`, (payload) => {
            if (channel.id === +channelRef.current) {
              const msg = JSON.parse(payload.body);
              setMsgList((msgList: ChatMessage[]) => [...msgList, msg]);
            } else {
              // alarm on
              const index = channelList.findIndex((el) => el.id === channel.id);
              const newList = [...channelList];
              newList[index] = { ...newList[index], alarm: true };
              dispatch(setChannelListRedux(newList));
            }
          });
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

  useEffect(() => {
    channelRef.current = channelId;
  }, [channelId]);

  return sendMessage;
}
