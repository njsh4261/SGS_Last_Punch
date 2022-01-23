import { RESPONSE } from '../constant';
import apiHandler from './handler';

const dummySize = 999; // todo: remove
const SIZE = 3;

export async function getWsListAPI(page: number) {
  const endpoint = `/workspace?page=${page}&size=${SIZE}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response.workspaces;
}

export async function getWsInfoAPI(wsId: number) {
  const endpoint = `/workspace/${wsId}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getMembersAPI(page: number, wsId: number) {
  const endpoint = `/workspace/${wsId}/members?page=${page}&size=${dummySize}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getChannelsAPI(page: number, wsId: number) {
  const endpoint = `/workspace/${wsId}/channels?page=${page}&size=${dummySize}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function createWsAPI(wsName: string, channelName: string) {
  const endpoint = `/workspace`;
  const body = {
    workspaceName: wsName,
    channelName,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response;
}
