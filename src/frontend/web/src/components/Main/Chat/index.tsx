import React from 'react';
import styled from 'styled-components';

import chatHook from '../../../hook/chat';
import ChatInput from './Input';
import Header from './Header';

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

const MessageBox = styled.section`
  display: flex;
  white-space: normal;
  word-break: break-all;
  padding: 8px 20px;
  &:hover {
    background: #f8f8f8;
  }
`;

const ChatInputLayout = styled.article`
  position: fixed;
  bottom: 0;
  right: 0;
  left: 260px;
  padding: 10px 20px 20px;
  background-color: white;
`;

const End = styled.article``;

const Chat = () => {
  const [channel, msg, msgList, endRef, msgTypingHandler, msgSubmitHandler] =
    chatHook();

  return (
    <>
      {channel.loading ? (
        <div>loading</div>
      ) : (
        <Container>
          <Header channelName={channel.name} />
          <MessageListContainer>
            {msgList?.map((msg, idx) => (
              <MessageBox key={idx}>{msg}</MessageBox>
            ))}
            <End ref={endRef}></End>
          </MessageListContainer>
          <ChatInputLayout>
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
