import React, { useState, useRef, useEffect } from 'react';
import styled from 'styled-components';
import expandIcon from '../icon/expand.svg';
import ChatInput from './ChatInput';

const Container = styled.main`
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const ChannelHeader = styled.article`
  display: flex;
  flex-shrink: 0;
  justify-content: space-between;
  padding: 8px 20px;
  border-bottom: 1px solid #e6e6e6;
`;

const ChannelInfo = styled.section`
  width: 100%;
  display: flex;
  &:hover {
    background: #f8f8f8f6;
    cursor: pointer;
  }
`;
const ChannelName = styled.article`
  display: block;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  font-weight: bold;
  margin-left: -8px;
  border-radius: 6px;
  padding: 3px 8px;
  font-size: 20px;

  @media only screen and (max-width: 400px) {
    max-width: 50vw;
  }
  @media only screen and (min-width: 400px) and (max-width: 650px) {
    max-width: 65vw;
  }
  @media only screen and (min-width: 650px) {
    max-width: 80vw;
  }
`;
const ArrowDropDownIcon = styled.article`
  display: inline-block;
  width: 20px;
  height: 20px;
  align-self: center;
  margin-right: 14px;
  background-image: url(${expandIcon});
  background-repeat: no-repeat;
`;

const MemberInfo = styled.button`
  flex: 0 0 auto;
`;

const MessageListContainer = styled.article`
  flex: 1;
  overflow-y: scroll;
  overflow-x: hidden;
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
  margin: 0 20px 20px 20px;
`;

const End = styled.article``;

const Chat = () => {
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<string[]>([]);
  const selectedChannel =
    '# dump channeldump channeldump channeldump channeldump channel'; // todo: store

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);
  const msgSubmitHandler = () => {
    if (msg !== '') {
      // socket.send(msg), get response
      setMsgList([...msgList, msg]);
      setMsg('');
    }
  };
  const scrollToBottom = () =>
    endRef.current?.scrollIntoView({ behavior: 'smooth' });

  useEffect(() => {
    scrollToBottom();
  }, [msgList]);

  return (
    <Container>
      <ChannelHeader>
        <ChannelInfo>
          <ChannelName>{selectedChannel}</ChannelName>
          <ArrowDropDownIcon></ArrowDropDownIcon>
        </ChannelInfo>

        <MemberInfo>member</MemberInfo>
      </ChannelHeader>
      <MessageListContainer>
        {msgList?.map((msg, idx) => (
          <MessageBox key={idx}>{msg}</MessageBox>
        ))}
        <End ref={endRef}></End>
      </MessageListContainer>
      <ChatInputLayout>
        <ChatInput
          msg={msg}
          msgTypingHandler={msgTypingHandler}
          msgSubmitHandler={msgSubmitHandler}
        ></ChatInput>
      </ChatInputLayout>
    </Container>
  );
};

export default Chat;