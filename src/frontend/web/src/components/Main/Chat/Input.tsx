import React from 'react';
import styled from 'styled-components';
import ImageButton from '../../Common/ImageButton';
import sendIcon from '../../../icon/send.svg';
import BoldIcon from '../../../icon/bold.svg';
import ItalicIcon from '../../../icon/italic.svg';
import StrikeIcon from '../../../icon/strike.svg';
import CodeIcon from '../../../icon/code.svg';
import ListBulletIcon from '../../../icon/list_bullet.svg';
import ListNumberIcon from '../../../icon/list_number.svg';
import LinkIcon from '../../../icon/link.svg';
import CodeBlockIcon from '../../../icon/code_block.svg';
import QuoteIcon from '../../../icon/quote.svg';
import EmailIcon from '../../../icon/email.svg';
import SmileIcon from '../../../icon/smile.svg';
import FileIcon from '../../../icon/file.svg';

const InputContainer = styled.article`
  border: 1px solid grey;
  border-radius: 6px;
  overflow: hidden;
  background: #f8f8f8;
`;

const InputLayer = styled.input`
  width: 100%;
  height: 38px;
  padding: 8px;
  outline: none;
  border: none;
  font-size: 15px;
`;

const ButtonLayer = styled.article`
  display: flex;
  justify-content: space-between;
  height: 32px;
  padding: 22px 12px;
  align-items: center;
`;

const LeftButtons = styled.section`
  display: flex;
`;

const RightButtons = styled.section`
  display: flex;
`;

interface ChatInputProps {
  channelName: string;
  msg: string;
  msgTypingHandler: (e: React.ChangeEvent<HTMLInputElement>) => void;
  msgSubmitHandler: () => void;
}

const ChatInput = ({
  channelName,
  msg,
  msgTypingHandler,
  msgSubmitHandler,
}: ChatInputProps) => {
  const enterKeyHandler = (e: React.KeyboardEvent<HTMLDivElement>) => {
    if (e.key === 'Enter') msgSubmitHandler();
  };

  return (
    <InputContainer>
      <InputLayer
        value={msg}
        onChange={msgTypingHandler}
        onKeyPress={enterKeyHandler}
        placeholder={`#${channelName}에게 메시지 보내기`}
      ></InputLayer>
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
