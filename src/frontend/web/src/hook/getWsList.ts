import { useState, useEffect } from 'react';
import { IWorkspace } from '../../types/workspace.type';
import { getWsListAPI } from '../Api/workspace';

export default function getWsListHook(): [
  wsList: IWorkspace[],
  getWsList: () => Promise<void>,
] {
  const [page, setPage] = useState(0);
  const [wsList, setWsList] = useState<IWorkspace[]>([]);

  const getWsList = async () => {
    const newWsList = await getWsListAPI(page);
    setWsList([...wsList, ...newWsList.content]);
    setPage((state) => state + 1);
  };

  useEffect(() => {
    getWsList();
  }, []);

  return [wsList, getWsList];
}
