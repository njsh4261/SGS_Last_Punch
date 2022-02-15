import React, { useMemo } from 'react';
import styled from 'styled-components';

import chatHook from '../../../hook/chat';
import ChatInput from './Input';
import Header from './Header';
import Loading from '../../Common/Loading';
import chatScrollHook from '../../../hook/chatScroll';

const Container = styled.main`
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const MessageListContainer = styled.article`
  flex: 1;
  max-height: calc(
    100% - 198px
  ); // hard coding. 198 is main-header, chat-header
  overflow-y: hidden;
  overflow-x: hidden;
  margin-bottom: 114px; // size of input
  :hover,
  :focus {
    overflow-y: auto;
  }
`;

const MessagItemContainer = styled.article<{ me?: boolean }>`
  display: flex;
  justify-content: ${({ me }) => me && `end`};
  text-align: ${({ me }) => (me ? 'end' : 'start')};
  white-space: normal;
  word-break: break-all;
  padding: 12px 20px;
  &:hover {
    background: #f8f8f8;
  }
`;

const MessageBox = styled.article`
  display: flex;
  flex-direction: column;
`;

const MessageHeader = styled.div<{ me: boolean }>`
  display: flex;
  flex-direction: ${({ me }) => (me ? 'row-reverse' : 'row')};
  align-items: flex-end;
`;

const MessageWriter = styled.div`
  font-weight: bold;
`;

const MessageCreated = styled.div`
  opacity: 50%;
  font-weight: 300;
  font-size: 8px;
  margin: 0 6px;
`;

const MessageContent = styled.div`
  display: inline-block;
`;

const ChatInputLayout = styled.article<{ toggle: boolean }>`
  position: fixed;
  bottom: 0;
  right: 0;
  left: ${({ toggle }) => (toggle ? '260px' : '0px')};
  padding: 10px 20px 20px;
  background-color: white;
  transition: left 300ms;
`;

const Start = styled.div`
  width: 100%;
  text-align: center;
`;

const End = styled.div``;

interface Props {
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

const Chat = ({ sideToggle, sideToggleHandler }: Props) => {
  const [
    user,
    channel,
    memberList,
    msg,
    msgList,
    setMsgList,
    msgTypingHandler,
    msgSubmitHandler,
  ] = chatHook();

  const userDictionary = useMemo(() => {
    const obj: { [index: string]: string } = {};
    memberList.map((member) => (obj[member.id] = member.name));
    return obj;
  }, [memberList]);

  const { scrollObserverRef, scrollLoading, endRef, chatBodyRef } =
    chatScrollHook(channel.id, msgList, setMsgList);

  return (
    <>
      {channel.loading ? (
        <Loading></Loading>
      ) : (
        <Container>
          <Header
            sideToggle={sideToggle}
            sideToggleHandler={sideToggleHandler}
            channel={channel}
          />
          <MessageListContainer ref={chatBodyRef}>
            <Start>{scrollLoading && <Loading></Loading>}</Start>
            {msgList?.map((msg, idx) => (
              <MessagItemContainer
                key={`message-${idx}`}
                me={msg.authorId === user.id.toString()}
                ref={idx === 0 ? scrollObserverRef : null}
                data-date={msg.createDt}
              >
                <MessageBox>
                  <MessageHeader me={msg.authorId === user.id.toString()}>
                    <MessageWriter>
                      {userDictionary[msg.authorId] || '알 수 없음'}
                    </MessageWriter>
                    <MessageCreated>
                      {msg.createDt.split(' ')[1].slice(0, 5)}
                    </MessageCreated>
                  </MessageHeader>
                  <MessageContent>{msg.content}</MessageContent>
                </MessageBox>
              </MessagItemContainer>
            ))}
            <End ref={endRef}></End>
          </MessageListContainer>
          <ChatInputLayout toggle={sideToggle}>
            <ChatInput
              channelName={channel.name}
              msg={msg}
              msgTypingHandler={msgTypingHandler}
              msgSubmitHandler={msgSubmitHandler}
            ></ChatInput>
          </ChatInputLayout>
        </Container>
      )}
    </>
  );
};

export default Chat;
