import { useEffect, useRef, useState } from 'react';
import cloneDeep from 'lodash/cloneDeep';

import { getOldChat } from '../Api/chat';
import { ChatMessage } from '../../types/chat.type';

export default function chatScrollHook(
  channelId: string,
  msgList: ChatMessage[],
  setMsgList: React.Dispatch<React.SetStateAction<ChatMessage[]>>,
) {
  const endRef = useRef<null | HTMLDivElement>(null);
  const throttler = useRef(false);
  const scrollObserverRef = useRef(null);
  const [scrollLoading, setScrollLoading] = useState(false);

  const option = {
    threshold: 0.3,
  };

  const getOldChatHandler = (entries: IntersectionObserverEntry[]) => {
    const [entry] = entries;

    if (entry.isIntersecting) {
      if (!throttler.current) {
        throttler.current = true;
        setTimeout(async () => {
          console.log('hello', entry.target); // console
          const date = (entry.target as HTMLElement).dataset.date;
          setScrollLoading(true);
          const response = await getOldChat(channelId.toString(), date!);
          if (response) {
            const old = cloneDeep(response.content);
            const current = cloneDeep(msgList);
            console.log({ old, current }); // console
            setMsgList([...old, ...current]);
          } else console.error('fail getting old message');
          setScrollLoading(false);
          throttler.current = false;
        }, 1000);
      }
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

  useEffect(() => {
    const observer = new IntersectionObserver(getOldChatHandler, option);
    if (scrollObserverRef.current) observer.observe(scrollObserverRef.current);

    return () => {
      if (scrollObserverRef.current) {
        observer.unobserve(scrollObserverRef.current);
      }
    };
  }, [msgList]);

  return { scrollObserverRef, scrollLoading, endRef };
}
