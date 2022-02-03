import React, { useState, useRef, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { v4 as uuidv4 } from 'uuid';

import { RootState } from '../modules';
import chatSocketHook from './chatSocket';
import { ChatMessage } from '../../types/chat.type';

export default function chatHook(): [
  dummyUser: { id: string; name: string },
  channel: RootState['channel'],
  msg: string,
  msgList: ChatMessage[],
  endRef: React.MutableRefObject<HTMLDivElement | null>,
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  msgSubmitHandler: () => void,
] {
  const channel = useSelector((state: RootState) => state.channel);
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<ChatMessage[]>([]);
  // dummy
  const [dummyUser, setUser] = useState({
    id: uuidv4(),
    name: uuidv4(),
  });

  const sendMessage = chatSocketHook(channel.id, setMsgList);

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);

  const msgSubmitHandler = () => {
    if (msg !== '') {
      sendMessage({
        sender: dummyUser.id,
        channelId: channel.id,
        content: msg,
      });
      // setMsgList([...msgList, msg]);
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
    dummyUser,
    channel,
    msg,
    msgList,
    endRef,
    msgTypingHandler,
    msgSubmitHandler,
  ];
}
