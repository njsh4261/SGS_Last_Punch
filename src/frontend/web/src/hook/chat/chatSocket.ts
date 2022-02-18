import React, { SetStateAction, useEffect, useRef, useState } from 'react';
import SockJS from 'sockjs-client';
import { Stomp, CompatClient } from '@stomp/stompjs';
import { useDispatch } from 'react-redux';
import cloneDeep from 'lodash/cloneDeep';

import { SendMessage, ChatMessage } from '../../../types/chat.type';
import { setChannelListRedux } from '../../modules/channeList';
import { setUserList } from '../../modules/userList';
import { TOKEN, URL, CHAT_TYPING_TIME } from '../../constant';

const HOST = URL.HOST;

export default function chatSocketHook(
  userId: number,
  wsId: string,
  channelId: string,
  setMsgList: React.Dispatch<SetStateAction<ChatMessage[]>>,
  channelList: any[],
  memberList: any[],
) {
  const channelRef = useRef(channelId);
  const dispatch = useDispatch();
  const [typingList, setTypingList] = useState(new Set());
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
      stompClient.debug = (f) => f;
      stompClient.connect({ Authorization: accessToken }, () => {
        // 채널 리스트에 대한 구독
        channelList.map((channel) => {
          stompClient.subscribe(`/topic/channel.${channel.id}`, (payload) => {
            if (channel.id === +channelRef.current) {
              const msg = JSON.parse(payload.body);
              if (msg.type === 'TYPING') {
                // add typing list & remove
                setTypingList((prev) => new Set([...prev, msg.authorId]));
                setTimeout(() => {
                  setTypingList(
                    (prev) =>
                      new Set(
                        [...prev].filter(
                          (authorId) => authorId !== msg.authorId,
                        ),
                      ),
                  );
                }, CHAT_TYPING_TIME);
              } else {
                setMsgList((msgList: ChatMessage[]) => [...msgList, msg]);
              }
            } else {
              // alarm on
              const index = channelList.findIndex((el) => el.id === channel.id);
              const newList = cloneDeep(channelList);
              newList[index] = { ...newList[index], alarm: true };
              dispatch(setChannelListRedux(newList));
            }
          });
        });
        // 멤버 리스트에 대한 구독
        memberList.map((member) => {
          const [low, high] =
            userId < member.id ? [userId, member.id] : [member.id, userId];
          if (low === high) return;
          stompClient.subscribe(
            `/topic/channel.${wsId}-${low}-${high}`,
            (payload) => {
              const msg = JSON.parse(payload.body);
              if (`${low}-${high}` === channelRef.current) {
                setMsgList((msgList: ChatMessage[]) => [...msgList, msg]);
              } else {
                // alarm on & update lastMessage(for rendring)
                const index = memberList.findIndex((el) => el.id === member.id);
                const newList = cloneDeep(memberList);
                newList[index] = {
                  ...newList[index],
                  alarm: true,
                  lastMessage: msg,
                };
                dispatch(setUserList(newList));
              }
            },
          );
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

  return { sendMessage, typingList };
}
