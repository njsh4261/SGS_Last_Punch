import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../modules';
import { Params, useParams } from 'react-router-dom';
import { selectWork } from '../modules/worksapce';

export default function getWsHook(): [params: Params, wsName: string] {
  const params = useParams();
  const dispatch = useDispatch();
  const wsName = useSelector((state: RootState) => state.work.name);

  const getWsInfo = async () => {
    const workspaceId = Number(params.wsId);
    dispatch(selectWork(workspaceId));
  };

  useEffect(() => {
    getWsInfo();
  }, []);

  return [params, wsName];
}
