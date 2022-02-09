import { useEffect, useRef } from 'react';

import { getOldChat } from '../Api/chat';
import { ChatMessage } from '../../types/chat.type';

export default function chatScrollHook(
  channelId: string,
  msgList: ChatMessage[],
  setMsgList: React.Dispatch<React.SetStateAction<ChatMessage[]>>,
) {
  const scrollObserverRef = useRef(null);

  const option = {
    threshold: 0.3,
  };

  const getOldChatHandler = async (
    entries: IntersectionObserverEntry[],
    observer: any,
  ) => {
    const [entry] = entries;
    console.log(entry);
    if (entry.isIntersecting) {
      const date = (entry.target as HTMLElement).dataset.date;
      if (date) {
        // const response = await getOldChat(channelId.toString(), date);
        // console.log({ response });
        console.log('hello api called');
      }
    }
  };

  useEffect(() => {
    const observer = new IntersectionObserver(getOldChatHandler, option);
    if (scrollObserverRef.current) observer.observe(scrollObserverRef.current);

    return () => {
      if (scrollObserverRef.current) {
        observer.unobserve(scrollObserverRef.current);
      }
    };
  }, [msgList]);

  return scrollObserverRef;
}
