import React, { useMemo } from 'react';
import styled, { css } from 'styled-components';
import { useParams } from 'react-router-dom';

import chatHook from '../../../hook/chat/index';
import ChatInput from './Input';
import Header from './Header';
import Loading from '../../Common/Loading';
import chatScrollHook from '../../../hook/chat/chatScroll';
import { ChatMessage } from '../../../../types/chat.type';
import './index.scss';
import presenceHook from '../../../hook/presence';

const Container = styled.main`
  flex: 1;
  display: flex;
  flex-direction: column;
  height: 100%;
`;

const ProfileImg = styled.div<{
  noHeader: boolean;
  imageNum: number | null;
}>`
  width: 34px;
  margin-right: 8px;
  font-size: 12px;
  color: white;
  cursor: pointer;
  ${({ noHeader, imageNum }) =>
    !noHeader &&
    css`
      height: 34px;
      border-radius: 4px;
      background-image: url(${require(`../../../images/${
        imageNum || 12
      }.png`)});
      background-size: contain;
    `}
`;

const MessageListContainer = styled.article`
  flex: 1;
  max-height: calc(
    100% - 198px
  ); // hard coding. 198 is main-header, chat-header
  overflow-y: hidden;
  overflow-x: hidden;
  margin-bottom: 114px; // size of input
  :hover,
  :focus {
    overflow-y: auto;
  }
`;

const MessagItemContainer = styled.article<{ me?: boolean }>`
  display: flex;
  align-items: center;
  justify-content: ${({ me }) => me && `end`};
  text-align: ${({ me }) => (me ? 'end' : 'start')};
  white-space: normal;
  word-break: break-all;
  padding: 8px 20px;
  &:hover {
    background: #f8f8f8;
  }
  &:hover ${ProfileImg} {
    color: gray;
  }
`;

const MessageBox = styled.article`
  width: 80%;
  display: flex;
  flex-direction: column;
`;

const MessageHeader = styled.div<{ me: boolean }>`
  display: flex;
  flex-direction: ${({ me }) => (me ? 'row-reverse' : 'row')};
  align-items: end;
  margin-bottom: 6px;
`;

const MessageWriter = styled.div`
  font-weight: bold;
`;

const MessageCreated = styled.div`
  opacity: 50%;
  font-weight: 300;
  font-size: 8px;
  margin: 0 6px;
  padding-bottom: 1px;
`;

const MessageContent = styled.div`
  font-size: 16px;
  padding-right: 2px;
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

const Start = styled.div`
  width: 100%;
  text-align: center;
`;

const End = styled.div``;

const TypingContainer = styled.article`
  color: darkgray;
  font-size: 14px;
`;

interface Props {
  sideToggle: boolean;
  sideToggleHandler: (e: React.MouseEvent<HTMLElement>) => void;
}

const Chat = ({ sideToggle, sideToggleHandler }: Props) => {
  const params = useParams();
  let prevAuthorId: string | undefined;
  const snow = new Array(50).fill(0); // for snow animation

  const [
    user,
    channel,
    memberList,
    typingList,
    msg,
    msgList,
    setMsgList,
    msgTypingHandler,
    msgSubmitHandler,
  ] = chatHook(params.wsId!);

  // presence 소켓 연결 및 유저들의 status 업데이트
  const sendMessage = presenceHook({ wsId: params.wsId! });

  const userDictionary = useMemo(() => {
    const obj: { [index: string]: { name: string; imageNum: number | null } } =
      {};
    memberList.map(
      (member) =>
        (obj[member.id] = {
          name: member.name,
          imageNum: member.imageNum,
        }),
    );
    return obj;
  }, [memberList]);

  const { scrollObserverRef, scrollLoading, endRef, chatBodyRef } =
    chatScrollHook(params.wsId!, channel.id, msgList, setMsgList);

  const isMe = (msg: ChatMessage) => {
    return msg.authorId === user.id.toString();
  };

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
            sendMessage={sendMessage}
          />
          {snow.map((el, index) => (
            <div key={'snow-' + index} className="snow"></div>
          ))}
          <MessageListContainer ref={chatBodyRef}>
            <Start>{scrollLoading && <Loading></Loading>}</Start>
            {msgList?.map((msg, idx) => {
              let noHeader = false;
              if (msg.authorId !== prevAuthorId) {
                prevAuthorId = msg.authorId;
              } else noHeader = true;
              return (
                <MessagItemContainer
                  key={`message-${idx}`}
                  me={isMe(msg)}
                  ref={idx === 0 ? scrollObserverRef : null}
                  data-date={msg.createDt}
                >
                  {!isMe(msg) && (
                    <ProfileImg
                      imageNum={userDictionary[msg.authorId].imageNum}
                      noHeader={noHeader}
                    >
                      {noHeader && msg.createDt.split(' ')[1].slice(0, 5)}
                    </ProfileImg>
                  )}
                  <MessageBox>
                    {!noHeader && (
                      <MessageHeader me={isMe(msg)}>
                        <MessageWriter>
                          {isMe(msg)
                            ? `나 (${userDictionary[msg.authorId].name})`
                            : userDictionary[msg.authorId].name || '알 수 없음'}
                        </MessageWriter>
                        <MessageCreated>
                          {msg.createDt.split(' ')[1].slice(0, 5)}
                        </MessageCreated>
                      </MessageHeader>
                    )}
                    <MessageContent>{msg.content}</MessageContent>
                  </MessageBox>
                </MessagItemContainer>
              );
            })}
            <End ref={endRef}></End>
          </MessageListContainer>
          <ChatInputLayout toggle={sideToggle}>
            {typingList.size !== 0 && (
              <TypingContainer>
                {Array.from(typingList).map((authorId, index) => (
                  <span key={'typing' + authorId}>
                    {userDictionary[authorId].name}
                    {index < typingList.size - 1 ? ', ' : ' '}
                  </span>
                ))}
                입력중...
              </TypingContainer>
            )}
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
