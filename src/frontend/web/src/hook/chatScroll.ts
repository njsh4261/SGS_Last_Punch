import { useEffect, useRef, useState } from 'react';

import { getOldChat } from '../Api/chat';
import { ChatMessage } from '../../types/chat.type';

export default function chatScrollHook(
  channelId: string,
  msgList: ChatMessage[],
  setMsgList: React.Dispatch<React.SetStateAction<ChatMessage[]>>,
) {
  const scrollObserverRef = useRef(null);
  const [scrollLoading, setScrollLoading] = useState(false);

  const option = {
    threshold: 0.3,
  };

  const getOldChatHandler = async (entries: IntersectionObserverEntry[]) => {
    const [entry] = entries;
    console.log(entry);
    if (entry.isIntersecting) {
      const date = (entry.target as HTMLElement).dataset.date;
      if (date) {
        setScrollLoading(true);
        setTimeout(() => setScrollLoading(false), 1000);
        // const response = await getOldChat(channelId.toString(), date);
        // console.log({ response });
        // setMsgList(old + current)
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

  return { scrollObserverRef, scrollLoading };
}
