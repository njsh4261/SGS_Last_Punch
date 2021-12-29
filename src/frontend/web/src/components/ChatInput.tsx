import React from 'react';
import styled from 'styled-components';
import sendIcon from '../icon/send.svg';
import BoldIcon from '../icon/bold.svg';
import ItalicIcon from '../icon/italic.svg';
import StrikeIcon from '../icon/strike.svg';
import CodeIcon from '../icon/code.svg';
import ListBulletIcon from '../icon/list_bullet.svg';
import ListNumberIcon from '../icon/list_number.svg';
import LinkIcon from '../icon/link.svg';
import CodeBlockIcon from '../icon/code_block.svg';
import QuoteIcon from '../icon/quote.svg';
import EmailIcon from '../icon/email.svg';
import SmileIcon from '../icon/smile.svg';
import FileIcon from '../icon/file.svg';

const InputContainer = styled.article`
  flex-shrink: 0;
  border: 1px solid grey;
  border-radius: 6px;
  overflow: hidden;
  /* todo: remove */
  width: 80%;
  margin: 20px;
`;

const InputLayer = styled.input`
  width: 100%;
  height: 38px;
  padding: 8px;
  outline: none;
  border: none;
`;

const ButtonLayer = styled.article`
  display: flex;
  justify-content: space-between;
  padding: 4px;
  align-items: center;
`;

const LeftButtons = styled.section`
  display: flex;
`;

const RightButtons = styled.section`
  display: flex;
`;

const ImageButton = styled.section<{ imageUrl: string; size?: string }>`
  background-image: url(${(props) => props.imageUrl});
  background-repeat: no-repeat;
  width: ${(props) => props.size || '25px'};
  height: ${(props) => props.size || '25px'};
  border: none;
  outline: none;

  & + & {
    /* todo: remove this */
    @media screen and (max-width: 500px) {
      margin-left: 7px;
    }
    @media screen and (min-width: 500px) {
      margin-left: 17px;
    }
  }
  &:hover {
    opacity: 50%;
    cursor: pointer;
  }
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
      <InputLayer value={msg} onChange={msgTypingHandler}></InputLayer>
      <ButtonLayer>
        <LeftButtons>
          <ImageButton imageUrl={BoldIcon}></ImageButton>
          <ImageButton imageUrl={ItalicIcon}></ImageButton>
          <ImageButton imageUrl={StrikeIcon}></ImageButton>
          <ImageButton imageUrl={CodeIcon}></ImageButton>
          <ImageButton imageUrl={LinkIcon}></ImageButton>
          <ImageButton imageUrl={ListNumberIcon}></ImageButton>
          <ImageButton imageUrl={ListBulletIcon}></ImageButton>
          <ImageButton imageUrl={QuoteIcon}></ImageButton>
          <ImageButton imageUrl={CodeBlockIcon}></ImageButton>
        </LeftButtons>
        <RightButtons>
          <ImageButton imageUrl={EmailIcon}></ImageButton>
          <ImageButton imageUrl={SmileIcon}></ImageButton>
          <ImageButton imageUrl={FileIcon}></ImageButton>
          <ImageButton
            onClick={msgSubmitHandler}
            imageUrl={sendIcon}
          ></ImageButton>
        </RightButtons>
      </ButtonLayer>
    </InputContainer>
  );
};

export default ChatInput;
