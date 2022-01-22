import axios from 'axios';
import { URL, ERROR_MESSAGE, TOKEN } from '../constant';

const PAGE = 0;
const SIZE = 3;

// todo: remove userId and set Token
export async function getWsListAPI(page: number) {
  const endpoint = `/workspace/page=${page}&size=${SIZE}`;

  try {
    const accessToken = sessionStorage.getItem(TOKEN.ACCESS);
    if (!accessToken) {
      // todo: type guard. 추후 처리 로직 삽입
      alert('토큰이 사라졌습니다!');
      return;
    }
    const response = await axios.get(URL.HOST + endpoint, {
      headers: {
        'X-AUTH-TOKEN': accessToken,
        // 'Content-Type': 'application/json',
      },
    });
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.LIST);
    return response.data.data;
  } catch (e) {
    return false;
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
