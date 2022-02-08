import { RESPONSE } from '../constant';
import apiHandler from './handler';
import { ICreateChannel } from '../../types/channel.type';

export async function getChannelInfoAPI(channelId: string) {
  const endpoint = `/channel/${channelId}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function createChannelAPI(body: ICreateChannel) {
  const endpoint = `/channel`;
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response;
}

export async function inviteChannelAPI(
  userId: number,
  channelId: number,
  roleId: 1,
) {
  const endpoint = `/channel/member`;
  const body = { accountId: userId, channelId, roleId };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response;
}

export async function exitChannelAPI(accountId: number, channelId: number) {
  const endpoint = `/channel/member?accountId=${accountId}&channelId=${channelId}`;
  const response = await apiHandler(
    'DELETE',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function getChannelMember(channelId: number | string) {
  const endpoint = `/channel/${channelId}/members`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}
