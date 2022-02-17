import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Params } from 'react-router-dom';
import { cloneDeep } from 'lodash';

import { RootState } from '../modules';
import { setUserList } from '../modules/userList';
import { ChannelListState, setChannelListRedux } from '../modules/channeList';
import { UserState } from '../modules/user';

interface Props {
  params: Params;
  memberList: UserState[];
  channelList: ChannelListState;
}

export default function alarmOffHook({
  params,
  memberList,
  channelList,
}: Props) {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);

  useEffect(() => {
    if (params.channelId?.split('-')) {
      // members
      const [low, high] = params.channelId.split('-');
      const targetId = user.id === +low ? high : low;
      const index = memberList.findIndex((el) => el.id.toString() === targetId);
      const newList = cloneDeep(memberList);
      if (newList[index]?.alarm) {
        newList[index] = { ...newList[index], alarm: false };
        dispatch(setUserList(newList));
      }
    } else {
      // channels
      const index = channelList.findIndex(
        (el) => el.id.toString() === params.channelId,
      );
      const newList = cloneDeep(channelList);
      if (newList[index]?.alarm) {
        newList[index] = { ...newList[index], alarm: false };
        dispatch(setChannelListRedux(newList));
      }
    }
  }, [params]);
}
