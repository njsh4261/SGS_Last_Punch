import React, { useState, useRef } from 'react';
import styled from 'styled-components';

const Container = styled.main`
  height: 90vh;
  background-color: beige;
`;

const MessageListContainer = styled.article`
  overflow: scroll;
  height: 90%;
  background-color: skyblue;
`;

const MessageBox = styled.section`
  display: flex;
  padding: 8px 20px;
`;

const InputContainer = styled.article`
  position: fixed;
  bottom: 0px;
  left: 0;
  right: 0;
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
    // if success
    setMsgList([...msgList, msg]);
    setMsg(`temp${msgList.length}`);
    scrollToBottom();
  };
  const scrollToBottom = () =>
    endRef.current?.scrollIntoView({ behavior: 'smooth' });

  return (
    <Container>
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
