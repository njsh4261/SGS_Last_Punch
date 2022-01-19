import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { useDispatch } from 'react-redux';
import { useNavigate, useParams } from 'react-router-dom';
import { selectChannel } from '../../../../modules/channel';
import ToggleList, { Text } from './ToggleList';
import { getChannelsAPI, getMembersAPI } from '../../../../Api/workspace';

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
  const [channelList, setChannelList] = useState([]);
  const [memberList, setMemberList] = useState([]);
  const params = useParams();
  const navigate = useNavigate();
  const dispatch = useDispatch();

  const selectHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const channel = e.currentTarget;
    dispatch(
      selectChannel(channel.id, channel.dataset.name as string, navigate),
    );
    document.title = channel.id;
  };

  const getChannelsNMembers = async () => {
    const workspaceId = Number(params.wsId);
    const { channels } = await getChannelsAPI(workspaceId);
    const { members } = await getMembersAPI(workspaceId);
    setMemberList(members.content);
    setChannelList(channels.content);
  };

  useEffect(() => {
    getChannelsNMembers();
  }, []);

  useEffect(() => {
    if (params.channelId) document.title = params.channelId as string;
  }, [params]);

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
        channelList={memberList}
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
