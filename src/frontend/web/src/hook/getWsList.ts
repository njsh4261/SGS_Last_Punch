import { useState, useEffect } from 'react';
import { IWorkspace } from '../../types/workspace.type';
import { getWsListAPI } from '../Api/workspace';
import { ERROR_MESSAGE } from '../constant';

export default function getWsListHook(): [
  wsList: IWorkspace[],
  getWsList: () => Promise<void>,
] {
  const [page, setPage] = useState(0);
  const [wsList, setWsList] = useState<IWorkspace[]>([]);

  const getWsList = async () => {
    const response = await getWsListAPI(page);
    if (response === undefined) {
      alert(ERROR_MESSAGE.SERVER);
      return;
    }
    setWsList([...wsList, ...response.workspaces.content]);
    setPage((state) => state + 1);
  };

  useEffect(() => {
    getWsList();
  }, []);

  return [wsList, getWsList];
}
