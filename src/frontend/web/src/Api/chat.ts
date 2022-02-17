import { RESPONSE } from '../constant';
import apiHandler from './handler';

export const getRecentChat = async (wsId: string, channelId: string) => {
  const endpoint = '/chat/recent';
  const body = {
    channelId: channelId.includes('-') ? `${wsId}-${channelId}` : channelId,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.CHAT.SUCCESS,
    body,
  );
  return response;
};

export const getOldChat = async (
  wsId: string,
  channelId: string,
  dateTime: string,
) => {
  const endpoint = '/chat/old';
  const body = {
    channelId: channelId.includes('-') ? `${wsId}-${channelId}` : channelId,
    dateTime,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.CHAT.SUCCESS,
    body,
  );
  return response;
};
