import axios from 'axios';
import { URL, ERROR_MESSAGE, TOKEN, RESPONSE } from '../constant';
import clearSession from '../util/clearSession';
import reissueAPI from './reissue';

const getAccessToken = () => sessionStorage.getItem(TOKEN.ACCESS);

export default async function apiHandler(
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  endpoint: string,
  successCode: string,
  body?: any, // todo: edit
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
    if (e.response.data.code === RESPONSE.TOKEN.EXPIRED) {
      return await reissueAPI();
    } else {
      alert(ERROR_MESSAGE.SERVER);
      clearSession();
    }
  }
}
