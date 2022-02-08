import React, { useMemo } from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import chatHook from '../../../hook/chat';
import ChatInput from './Input';
import Header from './Header';
import Loading from '../../Common/Loading';
import { RootState } from '../../../modules';

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

const MessagItemContainer = styled.article<{ me?: boolean }>`
  display: flex;
  justify-content: ${({ me }) => me && `end`};
  white-space: normal;
  word-break: break-all;
  padding: 8px 20px;
  &:hover {
    background: #f8f8f8;
  }
`;

const MessageBox = styled.article`
  display: flex;
  flex-direction: column;
`;

const MessageWriter = styled.div`
  font-weight: bold;
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

  const userList = useSelector((state: RootState) => state.userList);
  const userDictionary = useMemo(() => {
    const obj: { [index: string]: string } = {};
    userList.map((user) => (obj[user.id] = user.name));
    return obj;
  }, [userList]);

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
            {msgList?.map((msg, idx) => {
              return (
                <MessagItemContainer
                  key={idx}
                  me={msg.authorId === user.id.toString()}
                >
                  <MessageBox>
                    <MessageWriter>
                      {userDictionary[msg.authorId]}
                    </MessageWriter>
                    <MessageContent>{msg.content}</MessageContent>
                  </MessageBox>
                </MessagItemContainer>
              );
            })}
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
