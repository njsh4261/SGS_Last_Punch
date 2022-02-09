import { useSelector } from 'react-redux';
import { Params, useNavigate } from 'react-router-dom';
import { RootState } from '../modules';

export default function selectChannelHook(params: Params) {
  const navigate = useNavigate();
  const user = useSelector((state: RootState) => state.user);

  const selectChannelHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const channel = e.currentTarget;
    const wsId = params.wsId;
    if (channel.dataset.type === 'direct message') {
      const [low, high] =
        user.id < +channel.id ? [user.id, channel.id] : [channel.id, user.id];
      navigate(`/${wsId}/${low}-${high}`);
      document.title = `snack/${wsId}/${low}-${high}`;
    } else {
      navigate(`/${wsId}/${channel.id}`);
      document.title = `snack/${wsId}/${channel.id}`;
    }
  };
  return selectChannelHandler;
}
