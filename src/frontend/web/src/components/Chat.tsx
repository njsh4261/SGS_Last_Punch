import React, { useState, useRef } from 'react';
import styled from 'styled-components';

const Container = styled.main`
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const ChannelHeader = styled.article`
  display: flex;
  justify-content: space-between;
  padding: 8px 20px;
  border-bottom: 1px solid grey;
  background: white;
`;

const ChannelInfo = styled.section``;
const MemberInfo = styled.button``;

const MessageListContainer = styled.article`
  flex: 1;
  overflow: scroll;
  background-color: skyblue;
`;

const MessageBox = styled.section`
  display: flex;
  padding: 8px 20px;
  &:hover {
    background: grey;
  }
`;

const InputContainer = styled.article`
  flex-shrink: 0;
  padding: 8px 20px;
  background-color: grey;
`;

const Input = styled.input`
  width: 100%;
  height: 25px;
  border: none;
`;

const End = styled.article`
  height: 47px;
`;

const Chat = () => {
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('temp');
  const [msgList, setMsgList] = useState<string[]>([]);

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);
  const msgSubmitHandler = () => {
    // socket.send(msg), get response
    setMsgList([...msgList, msg]);
    setMsg(`temp${msgList.length}`);
    scrollToBottom();
  };
  const scrollToBottom = () =>
    endRef.current?.scrollIntoView({ behavior: 'smooth' });

  return (
    <Container>
      <ChannelHeader>
        <ChannelInfo>dump channel</ChannelInfo>
        <MemberInfo>member</MemberInfo>
      </ChannelHeader>
      <MessageListContainer>
        <div>chatting channel</div>
        <div>----</div>
        {msgList?.map((msg, idx) => (
          <MessageBox key={idx}>{msg}</MessageBox>
        ))}
        <End ref={endRef}></End>
      </MessageListContainer>
      <InputContainer>
        <Input value={msg} onChange={msgTypingHandler}></Input>
        <button onClick={msgSubmitHandler}>add msg</button>
      </InputContainer>
    </Container>
  );
};

export default Chat;
