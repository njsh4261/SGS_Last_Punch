import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import Swal from 'sweetalert2';
import { useParams } from 'react-router-dom';

import { RootState } from '../../modules';
import chatSocketHook from './chatSocket';
import { ChatMessage } from '../../../types/chat.type';
import { getRecentChat } from '../../Api/chat';

export default function chatHook(
  wsId: string,
): [
  user: RootState['user'],
  channel: RootState['channel'],
  memberList: RootState['userList'],
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

  const sendMessage = chatSocketHook(
    user.id,
    params.wsId!,
    channel.id,
    setMsgList,
    channelList,
    memberList,
  );

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);

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
    msg,
    msgList,
    setMsgList,
    msgTypingHandler,
    msgSubmitHandler,
  ];
}
