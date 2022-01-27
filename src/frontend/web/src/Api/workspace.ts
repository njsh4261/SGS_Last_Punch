import { ENDPOINT, RESPONSE } from '../constant';
import apiHandler from './handler';

const dummySize = 999; // todo: remove
const SIZE = 3;

type wsId = number;

export async function getWsListAPI(page: number) {
  const endpoint = `/workspace?page=${page}&size=${SIZE}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getWsInfoAPI(wsId: wsId) {
  const endpoint = `/workspace/${wsId}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getMembersAPI(page: number, wsId: wsId) {
  const endpoint = `/workspace/${wsId}/members?page=${page}&size=${dummySize}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getChannelsAPI(page: number, wsId: wsId) {
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

export async function inviteWsAPI(wsId: wsId) {
  const endpoint = `/workspace/member`;
  const body = {
    wsId,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response;
}
