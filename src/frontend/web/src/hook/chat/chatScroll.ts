import { useEffect, useRef, useState } from 'react';
import { useSelector } from 'react-redux';
import cloneDeep from 'lodash/cloneDeep';

import { getOldChat } from '../../Api/chat';
import { ChatMessage } from '../../../types/chat.type';
import { RootState } from '../../modules/index';

export default function chatScrollHook(
  wsId: string,
  channelId: string,
  msgList: ChatMessage[],
  setMsgList: React.Dispatch<React.SetStateAction<ChatMessage[]>>,
) {
  const chatBodyRef = useRef(null); // for scrollTo(old message)
  const MESSAGE_HIEHGT = 88; // for scrollTo
  const endRef = useRef<null | HTMLDivElement>(null); // for scorll to end(new message, recent message)
  const firstTime = useRef(true); // 최초 스크롤링 auto를 위한 상태
  const scrollObserverRef = useRef(null); // intersactionObserver
  const [scrollLoading, setLoading] = useState(false); // loading component
  const isOldMsgAdd = useRef(false);
  const noOldMsg = useRef(false);
  const modal = useSelector((state: RootState) => state.modal);

  const oObserverption = {
    threshold: 1,
  };

  const getOldChatHandler = async (entries: IntersectionObserverEntry[]) => {
    if (noOldMsg.current) return;
    const [entry] = entries;

    // 뷰포트에 잡힘
    if (entry.isIntersecting) {
      const target = entry.target as HTMLElement;
      const chatBodyElement = chatBodyRef.current as any;
      const date = target.dataset.date;

      // 예외 상황
      if (!chatBodyElement) {
        return;
      }
      // 채팅이 몇개 없을 때 렌더링 방지
      if (chatBodyElement.scrollHeight === chatBodyElement.clientHeight) {
        return;
      }

      setLoading(true);
      const response = await getOldChat(wsId, channelId.toString(), date!);
      if (response) {
        const current = cloneDeep(msgList);
        const old = cloneDeep(response.content);

        if (old.length !== 0) {
          chatBodyElement.scrollTo(0, MESSAGE_HIEHGT * old.length);
          isOldMsgAdd.current = true;
          setMsgList([...old, ...current]);
        } else {
          noOldMsg.current = true;
        }
      } else console.error('fail getting old message');
    }
    setLoading(false);
  };

  const scrollToBottom = (behavior: 'smooth' | 'auto') => {
    endRef.current?.scrollIntoView({
      behavior,
    });
  };

  useEffect(() => {
    firstTime.current = true;
    noOldMsg.current = false;
  }, [channelId, modal, channelId]);

  // scroll to bottom
  useEffect(() => {
    if (firstTime.current) {
      firstTime.current = false;
    }
    scrollToBottom('auto');
  }, [msgList]);

  useEffect(() => {
    const observer = new IntersectionObserver(
      getOldChatHandler,
      oObserverption,
    );
    if (scrollObserverRef.current) observer.observe(scrollObserverRef.current);

    return () => {
      if (scrollObserverRef.current) {
        observer.unobserve(scrollObserverRef.current);
      }
    };
  }, [msgList]);

  return { scrollObserverRef, scrollLoading, endRef, chatBodyRef };
}
