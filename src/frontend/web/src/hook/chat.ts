import React, { useState, useRef, useEffect } from 'react';
import { useSelector } from 'react-redux';
import Swal from 'sweetalert2';

import { RootState } from '../modules';
import chatSocketHook from './chatSocket';
import { ChatMessage } from '../../types/chat.type';
import { getRecentChat } from '../Api/chat';

export default function chatHook(): [
  user: RootState['user'],
  channel: RootState['channel'],
  memberList: RootState['userList'],
  msg: string,
  msgList: ChatMessage[],
  setMsgList: React.Dispatch<React.SetStateAction<ChatMessage[]>>,
  endRef: React.MutableRefObject<HTMLDivElement | null>,
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  msgSubmitHandler: () => void,
] {
  const user = useSelector((state: RootState) => state.user);
  const channel = useSelector((state: RootState) => state.channel);
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<ChatMessage[]>([]);
  const channelList = useSelector((state: RootState) => state.channelList);
  const memberList = useSelector((state: RootState) => state.userList);

  const sendMessage = chatSocketHook(
    user.id,
    channel.id,
    setMsgList,
    channelList,
    memberList,
  );

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

  const getRecentChatHandler = async () => {
    const response = await getRecentChat(channel.id);
    if (response) {
      setMsgList(response.content);
    } else {
      Swal.fire(response.err, '', 'error');
    }
  };

  useEffect(() => {
    scrollToBottom();
  }, [msgList]);

  useEffect(() => {
    getRecentChatHandler();
  }, [channel]);

  return [
    user,
    channel,
    memberList,
    msg,
    msgList,
    setMsgList,
    endRef,
    msgTypingHandler,
    msgSubmitHandler,
  ];
}
