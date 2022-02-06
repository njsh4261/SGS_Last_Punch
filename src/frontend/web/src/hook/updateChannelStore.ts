import { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import { Params, useNavigate } from 'react-router-dom';
import { selectChannel } from '../modules/channel';

export default function updateChannelStoreHook(params: Params) {
  const dispatch = useDispatch();

  useEffect(() => {
    const { channelId } = params;
    if (channelId) dispatch(selectChannel(channelId));
  }, [params]);
}
