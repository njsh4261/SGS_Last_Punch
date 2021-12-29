import React from 'react';
import styled from 'styled-components';

const InputContainer = styled.article`
  flex-shrink: 0;
  padding: 8px 20px;
`;

const Input = styled.input`
  width: 100%;
  height: 25px;
`;

interface ChatInputProps {
  msg: string;
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
  msgSubmitHandler: () => void;
}

const ChatInput = ({
  msg,
  msgTypingHandler,
  msgSubmitHandler,
}: ChatInputProps) => {
  return (
    <InputContainer>
      <Input value={msg} onChange={msgTypingHandler}></Input>
      <button onClick={msgSubmitHandler}>add msg</button>
    </InputContainer>
  );
};

export default ChatInput;
