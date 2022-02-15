import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Params } from 'react-router-dom';

import { RootState } from '../modules';
import { selectChannel, selectDM } from '../modules/channel';

export default function updateChannelStoreHook(
  params: Params,
  memberList: RootState['userList'],
) {
  const user = useSelector((state: RootState) => state.user);
  const dispatch = useDispatch();

  useEffect(() => {
    const { channelId } = params;
    // channelId는 채널(channelId), DM({userId}-{userId})
    if (channelId) {
      // 채널
      if (channelId.indexOf('-') === -1) {
        // redux-saga로 채널 정보를 받아와 적용시킴
        dispatch(selectChannel(channelId));
      } else {
        // DM: 상대 userName store에 저장
        const [low, high] = channelId.split('-');
        let targetId, targetName;
        if (user.id === +low) targetId = high;
        else targetId = low;
        for (let i = 0; i < memberList.length; i += 1) {
          if (memberList[i].id === +targetId) {
            targetName = memberList[i].name;
            break;
          }
        }
        if (targetName) dispatch(selectDM(channelId, targetName));
      }
    }
  }, [params, memberList]);
}
