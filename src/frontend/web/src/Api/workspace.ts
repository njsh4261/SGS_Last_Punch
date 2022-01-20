import axios from 'axios';
import { HOST, ERROR_MESSAGE } from '../constant';

// todo: remove userId and set Token
export async function getWsListAPI(userId: string) {
  const endpoint = `/workspace/?userId=${userId}`;

  try {
    const response = await axios.get(HOST + endpoint);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.LIST);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function getWsInfoAPI(wsId: number) {
  const endpoint = `/workspace/${wsId}`;

  try {
    const response = await axios.get(HOST + endpoint);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.INFO);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function getMembersAPI(wsId: number) {
  const endpoint = `/workspace/${wsId}/members`;

  try {
    const response = await axios.get(HOST + endpoint);
    if (response.status !== 200)
      throw new Error(ERROR_MESSAGE.WORKSPACE.MEMBERS);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function getChannelsAPI(wsId: number) {
  const page = 0;
  const size = 15;
  const endpoint = `/workspace/${wsId}/channels?page=${page}&size=${size}`;

  try {
    const response = await axios.get(HOST + endpoint);
    if (response.status !== 200)
      throw new Error(ERROR_MESSAGE.WORKSPACE.CHANNELS);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function createWsAPI(wsName: string, channelName: string) {
  const endpoint = `/workspace`;
  const data = {
    creatorId: 1, // test code
    workspaceName: wsName,
    channelName,
  };

  try {
    const response = await axios.post(HOST + endpoint, data);
    if (response.status !== 200)
      throw new Error(ERROR_MESSAGE.WORKSPACE.CREATE);
    return response;
  } catch (e) {
    return false;
  }
}
