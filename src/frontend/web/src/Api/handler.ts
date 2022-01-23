import axios from 'axios';
import { URL, ERROR_MESSAGE, TOKEN, RESPONSE } from '../constant';
import clearSession from '../util/clearSession';
import reissueAPI from './reissue';
import { ICreateWs } from '../../types/workspace.type';
import { ICreateChannel } from '../../types/channel.type';

const getAccessToken = () => sessionStorage.getItem(TOKEN.ACCESS);

async function apiHandler(
  method: 'GET',
  endpoint: string,
  successCode: string,
): Promise<any>;

async function apiHandler(
  method: 'POST',
  endpoint: string,
  successCode: string,
  body: ICreateWs | ICreateChannel,
): Promise<any>;

async function apiHandler(
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  endpoint: string,
  successCode: string,
  body?: ICreateWs | ICreateChannel,
) {
  try {
    const accessToken = getAccessToken();
    if (!accessToken) {
      alert('no access token');
      return;
    }
    const option = {
      headers: { 'X-AUTH-TOKEN': accessToken },
    };
    if (method === 'GET') {
      const response = await axios.get(URL.HOST + endpoint, option);
      const { code, data, err } = response.data;
      if (code === successCode) return data;
    }
    if (method === 'POST') {
      const response = await axios.post(URL.HOST + endpoint, body, option);
      const { code, data, err } = response.data;
      if (code === successCode) return data;
    }
    // todo:
    throw 'todo: 각 코드에 따른 처리 고려';
  } catch (e: any) {
    if (e.response?.data.code === RESPONSE.TOKEN.EXPIRED) {
      await reissueAPI();
    } else {
      alert(ERROR_MESSAGE.SERVER);
      clearSession();
    }
  }
}

export default apiHandler;
