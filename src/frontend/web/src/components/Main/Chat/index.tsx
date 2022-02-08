import React from 'react';
import styled from 'styled-components';

import chatHook from '../../../hook/chat';
import ChatInput from './Input';
import Header from './Header';
import Loading from '../../Common/Loading';

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
  overflow-y: scroll;
  overflow-x: hidden;
  margin-bottom: 114px; // size of input
`;

const MessageBox = styled.article<{ me?: boolean }>`
  display: flex;
  justify-content: ${({ me }) => me && `end`};
  white-space: normal;
  word-break: break-all;
  padding: 8px 20px;
  &:hover {
    background: #f8f8f8;
  }
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

const End = styled.article``;

interface Props {
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

const Chat = ({ sideToggle, sideToggleHandler }: Props) => {
  const [
    user,
    channel,
    msg,
    msgList,
    endRef,
    msgTypingHandler,
    msgSubmitHandler,
  ] = chatHook();

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
          <MessageListContainer>
            {msgList?.map((msg, idx) => (
              <MessageBox key={idx} me={msg.authorId === user.id.toString()}>
                <MessageContent>{msg.content}</MessageContent>
              </MessageBox>
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
