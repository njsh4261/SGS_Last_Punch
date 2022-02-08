import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';

import { RootState } from '../modules';
import { Params, useNavigate, useParams } from 'react-router-dom';
import { getChannelsAPI, getMembersAPI } from '../Api/workspace';
import { setUserList } from '../modules/userList';
import { setChannelListRedux } from '../modules/channeList';

export default function getChannelsAndMembersHook(): [params: Params] {
  const navigate = useNavigate();
  const modalActive = useSelector((state: RootState) => state.modal.active);
  const params = useParams();
  const dispatch = useDispatch();

  const getChannelsNMembers = async () => {
    const workspaceId = Number(params.wsId);
    const resChannels = await getChannelsAPI(0, workspaceId);
    const resMembers = await getMembersAPI(0, workspaceId);
    if (resChannels) {
      dispatch(setChannelListRedux(resChannels.channels.content));
      if (!params.channelId) {
        navigate(`/${workspaceId}/${resChannels.channels.content[0].id}`);
      }
    }
    if (resMembers) {
      dispatch(setUserList(resMembers.members.content));
    }
  };

  useEffect(() => {
    if (!modalActive) getChannelsNMembers();
  }, [modalActive]);

  return [params];
}
