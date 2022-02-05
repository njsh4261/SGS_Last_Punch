import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Params, useParams } from 'react-router-dom';

import { RootState } from '../modules';
import { selectWork } from '../modules/worksapce';

export default function getWsHook(): [params: Params, ws: RootState['work']] {
  const params = useParams();
  const dispatch = useDispatch();
  const ws = useSelector((state: RootState) => state.work);

  const getWsInfo = async () => {
    const workspaceId = Number(params.wsId);
    dispatch(selectWork(workspaceId));
  };

  useEffect(() => {
    getWsInfo();
  }, []);

  return [params, ws];
}
