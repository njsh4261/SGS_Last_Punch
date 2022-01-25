import { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';

import { RootState } from '../modules';
import { Params, useParams } from 'react-router-dom';
import { getChannelsAPI, getMembersAPI } from '../Api/workspace';

export default function getChannelsAndMembersHook(): [
  channelList: any[],
  memberList: any[],
  params: Params,
] {
  const [channelPage, setChannelPage] = useState(0);
  const [memberPage, setMemberPage] = useState(0);
  const [channelList, setChannelList] = useState([]);
  const [memberList, setMemberList] = useState([]);
  const modalActive = useSelector((state: RootState) => state.modal.active);
  const params = useParams();

  const getChannelsNMembers = async () => {
    const workspaceId = Number(params.wsId);
    const { channels } = await getChannelsAPI(channelPage, workspaceId);
    const { members } = await getMembersAPI(memberPage, workspaceId);
    setMemberList(members.content);
    setChannelList(channels.content);
  };

  useEffect(() => {
    if (!modalActive) getChannelsNMembers();
  }, [modalActive]);

  return [channelList, memberList, params];
}
