import React, { useState, useRef, useEffect } from 'react';
import { Params } from 'react-router-dom';
import styled from 'styled-components';
import { useSelector, useDispatch } from 'react-redux';
import { selectChannel } from '../../../modules/channel';
import { RootState } from '../../../modules';
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

const Chat = ({ params }: { params: Params }) => {
  const dispatch = useDispatch();
  const channel = useSelector((state: RootState) => state.channel);
  const endRef = useRef<null | HTMLDivElement>(null);
  const [msg, setMsg] = useState<string>('');
  const [msgList, setMsgList] = useState<string[]>([]);

  const msgTypingHandler = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMsg(e.target.value);

  const msgSubmitHandler = () => {
    if (msg !== '') {
      // todo: socket.send(msg), get response
      setMsgList([...msgList, msg]);
      setMsg('');
    }
  };
  const scrollToBottom = () =>
    endRef.current?.scrollIntoView({ behavior: 'smooth' });

  useEffect(() => {
    const { channelId } = params;
    if (channelId) dispatch(selectChannel(channelId));
    else alert('no channelId Main/Chat/index');
  }, [params]);

  useEffect(() => {
    scrollToBottom();
  }, [msgList]);

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
