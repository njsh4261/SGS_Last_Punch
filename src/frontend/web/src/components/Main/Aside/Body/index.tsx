import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';
import { RootState } from '../../../../modules';
import { useNavigate, useParams } from 'react-router-dom';
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
  const [channelPage, setChannelPage] = useState(0);
  const [memberPage, setMemberPage] = useState(0);
  const [channelList, setChannelList] = useState([]);
  const [memberList, setMemberList] = useState([]);
  const modalActive = useSelector((state: RootState) => state.modal.active);
  const params = useParams();
  const navigate = useNavigate();

  const selectHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const channel = e.currentTarget;
    const wsId = params.wsId;
    document.title = channel.id;
    navigate(`/${wsId}/${channel.id}`);
  };

  const getChannelsNMembers = async () => {
    const workspaceId = Number(params.wsId);
    const { channels } = await getChannelsAPI(channelPage, workspaceId);
    const { members } = await getMembersAPI(memberPage, workspaceId);
    setMemberList(members.content);
    setChannelList(channels.content);
  };

  // todo: get more list channel/member

  useEffect(() => {
    if (!modalActive) getChannelsNMembers();
  }, [modalActive]);

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
    </Container>
  );
}
