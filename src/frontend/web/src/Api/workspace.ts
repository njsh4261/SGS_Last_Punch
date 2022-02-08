import { RESPONSE } from '../constant';
import apiHandler from './handler';

const dummySize = 999; // todo: remove
const SIZE = 3;

type WsId = number;

export async function getWsListAPI(page: number) {
  const endpoint = `/workspace?page=${page}&size=${SIZE}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getWsInfoAPI(wsId: WsId) {
  const endpoint = `/workspace/${wsId}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getMembersAPI(page: number, wsId: WsId) {
  const endpoint = `/workspace/${wsId}/members?page=${page}&size=${dummySize}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getChannelsAPI(page: number, wsId: WsId) {
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

export async function inviteWsAPI(wsId: number, userId: number) {
  const endpoint = `/workspace/member`;
  const body = {
    workspaceId: wsId,
    accountId: userId,
    roleId: 1,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response;
}

export async function exitWsAPI(wsId: number, userId: number) {
  const endpoint = `/workspace/member`;
  const body = {
    workspaceId: wsId,
    accountId: userId,
  };
  const response = await apiHandler(
    'DELETE',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response;
}
