import { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import cloneDeep from 'lodash/cloneDeep';

import { RootState } from '../modules';
import { Params, useNavigate, useParams } from 'react-router-dom';
import { getChannelsAPI, getMembersAPI } from '../Api/workspace';
import { setUserList } from '../modules/userList';
import { setChannelListRedux } from '../modules/channeList';

export default function getChannelsAndMembersHook(): [params: Params] {
  const navigate = useNavigate();
  const modalActive = useSelector((state: RootState) => state.modal.active);
  const memberList = useSelector((state: RootState) => state.userList);
  const params = useParams();
  const dispatch = useDispatch();

  const getChannels = async () => {
    const workspaceId = Number(params.wsId);
    const resChannels = await getChannelsAPI(0, workspaceId);

    if (resChannels) {
      dispatch(setChannelListRedux(resChannels.channels.content));
      if (!params.channelId) {
        navigate(`/${workspaceId}/${resChannels.channels.content[0].id}`);
      }
    }
  };

  const getMembers = async () => {
    const workspaceId = Number(params.wsId);
    const resMembers = await getMembersAPI(0, workspaceId);

    if (resMembers) {
      const serverMembers: any[] = cloneDeep(resMembers.members.content);
      const clientMembers = memberList;

      if (clientMembers.length > 0) {
        // server, client member list의 순서가 항상 동일하다고 전제
        for (let i = 0; i < serverMembers.length; i += 1) {
          // 임시 오픈 (DM 보낼 상대만 정하고 메시지 보내기 전의 상태)
          if (clientMembers[i].lastMessage.createDt === true) {
            serverMembers[i].lastMessage.createDt = true;
          }
        }
      }
      dispatch(setUserList(serverMembers));
    }
  };

  useEffect(() => {
    if (!modalActive) getChannels();
  }, [modalActive]);

  useEffect(() => {
    getMembers();
  }, []);

  return [params];
}
