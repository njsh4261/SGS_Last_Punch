import { RESPONSE } from '../constant';
import apiHandler from './handler';

export const getRecentChat = async (channelId: string) => {
  const endpoint = '/chat/recent';
  const body = {
    channelId,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.CHAT.SUCCESS,
    body,
  );
  return response;
};

export const getOldChat = async (channelId: string, dateTime: string) => {
  const endpoint = '/chat/old';
  const body = {
    channelId,
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
