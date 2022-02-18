import React, { useState, useEffect, useRef } from 'react';
import { useSelector } from 'react-redux';
import Swal from 'sweetalert2';
import { useParams } from 'react-router-dom';

import { RootState } from '../../modules';
import chatSocketHook from './chatSocket';
import { ChatMessage } from '../../../types/chat.type';
import { getRecentChat } from '../../Api/chat';
import { CHAT_TYPING_TIME } from '../../constant';

export default function chatHook(
  wsId: string,
): [
  user: RootState['user'],
  channel: RootState['channel'],
  memberList: RootState['userList'],
  typingList: Set<any>,
  msg: string,
  msgList: ChatMessage[],
  setMsgList: React.Dispatch<React.SetStateAction<ChatMessage[]>>,
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  msgSubmitHandler: () => void,
] {
  const params = useParams();
  const user = useSelector((state: RootState) => state.user);
  const channel = useSelector((state: RootState) => state.channel);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<ChatMessage[]>([]);
  const channelList = useSelector((state: RootState) => state.channelList);
  const memberList = useSelector((state: RootState) => state.userList);
  const isTyping = useRef(false);

  const { sendMessage, typingList } = chatSocketHook(
    user.id,
    params.wsId!,
    channel.id,
    setMsgList,
    channelList,
    memberList,
  );

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
    setMsg(e.target.value);
    // 소켓으로 입력 중이라는 메시지 전송
    if (isTyping.current === false) {
      isTyping.current = true;
      sendMessage({
        authorId: user.id.toString(),
        channelId: channel.id.toString().includes('-')
          ? params.wsId + '-' + channel.id.toString()
          : channel.id.toString(),
        type: 'TYPING',
      });
      setTimeout(() => {
        isTyping.current = false;
      }, CHAT_TYPING_TIME);
    }
  };

  const msgSubmitHandler = () => {
    if (msg !== '') {
      const channelId = channel.id.toString();

      sendMessage({
        authorId: user.id.toString(),
        channelId: channelId.includes('-')
          ? params.wsId + '-' + channel.id.toString()
          : channel.id.toString(),
        content: msg,
      });
      setMsg('');
    }
  };

  const getRecentChatHandler = async () => {
    const response = await getRecentChat(wsId, channel.id.toString());
    if (response) {
      setMsgList(response.content);
    } else {
      Swal.fire(response.err, '', 'error');
    }
  };

  useEffect(() => {
    getRecentChatHandler();
  }, [channel]);

  return [
    user,
    channel,
    memberList,
    typingList,
    msg,
    msgList,
    setMsgList,
    msgTypingHandler,
    msgSubmitHandler,
  ];
}
