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
    if (channelId) {
      if (channelId.indexOf('-') === -1) {
        dispatch(selectChannel(channelId));
      } else {
        const [low, high] = channelId.split('-');
        let targetId, targetName;
        if (user.id === +low) targetId = high;
        else targetId = low;
        for (let i = 0; i < memberList.length; i += 1) {
          if (memberList[i].id === +targetId) {
            targetName = memberList[i].name;
          }
        }
        if (targetName) dispatch(selectDM(channelId, targetName));
      }
    }
  }, [params]);
}
