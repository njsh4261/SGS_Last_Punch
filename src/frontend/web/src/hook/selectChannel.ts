import { Params, useNavigate } from 'react-router-dom';

export default function selectChannelHook(params: Params) {
  const navigate = useNavigate();
  const selectChannelHandler = (e: React.MouseEvent<HTMLDivElement>) => {
    const channel = e.currentTarget;
    const wsId = params.wsId;
    document.title = channel.id;
    navigate(`/${wsId}/${channel.id}`);
  };
  return selectChannelHandler;
}
