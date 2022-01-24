import React, { useState, useRef, useEffect, Ref } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../modules';

export default function chatHook(): [
  channel: RootState['channel'],
  msg: string,
  msgList: string[],
  endRef: React.MutableRefObject<HTMLDivElement | null>,
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void,
  msgSubmitHandler: () => void,
] {
  const channel = useSelector((state: RootState) => state.channel);
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<string[]>([]);

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);

  const msgSubmitHandler = () => {
    if (msg !== '') {
      // todo: socket.send(msg), get response
      setMsgList([...msgList, msg]);
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

  return [channel, msg, msgList, endRef, msgTypingHandler, msgSubmitHandler];
}
