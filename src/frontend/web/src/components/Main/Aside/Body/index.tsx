import React, { useState } from 'react';
import styled from 'styled-components';
import ToggleList, { Text } from './ToggleList';

const Container = styled.article`
  padding-top: 8px;
  display: flex;
  flex-direction: column;
  color: rgb(207, 195, 207);
  font-size: 14px;
  overflow-y: scroll;
`;

const SecitonType = styled.section`
  padding: 8px 0px;
  &:hover {
    background-color: ${(props) => props.theme.color.heavySlack};
  }
`;

export default function AsideBody() {
  // dummy data
  const channelList = [
    { id: 'ss1', name: '공지' },
    { id: '2a', name: '수다방' },
    { id: '3zz', name: '회의록' },
  ];
  const dmList = [
    { id: 'dm1', name: '김지수', userId: 'sd2' },
    { id: 'dm2', name: '김지효', userId: 'asa2' },
    { id: 'dm3', name: '김건형', userId: 'sdsds' },
    { id: 'dm4', name: '나', userId: 'avdnsk3' },
  ];

  const [selectedChannel, selectChannel] = useState(channelList[0].id); // todo: redux - store

  const selectHandler = (e: React.MouseEvent<HTMLElement>) => {
    const channel = (e.target as Element).closest('.channel-item') as Element;
    selectChannel(channel.id);
    console.log(channel.id);
  };

  return (
    <Container>
      <SecitonType>
        <Text>알림</Text>
      </SecitonType>
      <ToggleList
        channelList={channelList}
        selectHandler={selectHandler}
        type="channel"
      ></ToggleList>
      <ToggleList
        channelList={dmList}
        selectHandler={selectHandler}
        type="direct message"
      ></ToggleList>
      {/** remove test code*/}
      <SecitonType>
        <Text>
          overflow test. overflow test. overflow test. overflow test. overflow
          test.{' '}
        </Text>
      </SecitonType>
    </Container>
  );
}
