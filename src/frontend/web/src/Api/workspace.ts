import axios from 'axios';
import { URL, ERROR_MESSAGE, TOKEN, RESPONSE } from '../constant';
import reissueAPI from './reissue';

const PAGE = 0; // todo: remove
const SIZE = 3;

// todo: remove userId and set Token
export async function getWsListAPI(page: number) {
  const endpoint = `/workspace?page=${page}&size=${SIZE}`;

  try {
    const accessToken = sessionStorage.getItem(TOKEN.ACCESS);
    if (!accessToken) {
      alert('no access token');
      return;
    }
    const response = await axios.get(URL.HOST + endpoint, {
      headers: { 'X-AUTH-TOKEN': accessToken },
    });

    const { code, data, err } = response.data;
    // todo: 각 code에 따른 처리 어떻게할지, err올떄만 처리할까?
    if (code === RESPONSE.WORKSPACE.SUCCESS) {
      return data;
    } else return;
  } catch (e: any) {
    // todo: error type
    if (e.response.data.code === RESPONSE.TOKEN.EXPIRED) {
      return await reissueAPI();
    } else {
      alert(ERROR_MESSAGE.SERVER);
    }
  }
}

export async function getWsInfoAPI(wsId: number) {
  const endpoint = `/workspace/${wsId}`;

  try {
    const response = await axios.get(URL.HOST + endpoint);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.INFO);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function getMembersAPI(wsId: number) {
  const endpoint = `/workspace/${wsId}/members?page=${PAGE}&size=${SIZE}`;

  try {
    const response = await axios.get(URL.HOST + endpoint);
    if (response.status !== 200)
      throw new Error(ERROR_MESSAGE.WORKSPACE.MEMBERS);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function getChannelsAPI(wsId: number) {
  const endpoint = `/workspace/${wsId}/channels?page=${PAGE}&size=${SIZE}`;

  try {
    const response = await axios.get(URL.HOST + endpoint);
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
    const response = await axios.post(URL.HOST + endpoint, data);
    if (response.status !== 200)
      throw new Error(ERROR_MESSAGE.WORKSPACE.CREATE);
    return response;
  } catch (e) {
    return false;
  }
}
