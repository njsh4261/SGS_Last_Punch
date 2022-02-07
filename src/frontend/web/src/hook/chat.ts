import React, { useState, useRef, useEffect } from 'react';
import { useSelector } from 'react-redux';

import { RootState } from '../modules';
import chatSocketHook from './chatSocket';
import { ChatMessage } from '../../types/chat.type';

export default function chatHook(): [
  user: RootState['user'],
  channel: RootState['channel'],
  msg: string,
  msgList: ChatMessage[],
  endRef: React.MutableRefObject<HTMLDivElement | null>,
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  msgSubmitHandler: () => void,
] {
  const user = useSelector((state: RootState) => state.user);
  const channel = useSelector((state: RootState) => state.channel);
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<ChatMessage[]>([]);

  const sendMessage = chatSocketHook(channel.id, setMsgList);

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);

  const msgSubmitHandler = () => {
    if (msg !== '') {
      sendMessage({
        authorId: user.id.toString(),
        channelId: channel.id.toString(),
        content: msg,
      });
      setMsg('');
    }
  };
  const scrollToBottom = () =>
    endRef.current?.scrollIntoView({
      behavior: 'smooth',
      block: 'nearest',
    });

  useEffect(() => {
    scrollToBottom();
  }, [msgList]);

  return [
    user,
    channel,
    msg,
    msgList,
    endRef,
    msgTypingHandler,
    msgSubmitHandler,
  ];
}
