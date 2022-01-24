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
