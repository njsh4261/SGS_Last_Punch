import axios from 'axios';
import { URL, ERROR_MESSAGE, TOKEN, RESPONSE } from '../constant';
import clearSession from '../util/clearSession';
import reissueAPI from './reissue';

const getAccessToken = () => sessionStorage.getItem(TOKEN.ACCESS);

async function apiHandler(
  method: 'GET',
  endpoint: string,
  successCode: string,
  needToken?: boolean,
): Promise<any>;

async function apiHandler(
  method: 'POST',
  endpoint: string,
  successCode: string,
  body: any,
  needToken?: boolean,
): Promise<any>;

/** RETURN
 * ERROR: err{msg, desc: ERROR_MESSAGE}
 * SUCCESS:
 *    if(data) data
 *    else code: RESPONSE
 */
async function apiHandler(
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  endpoint: string,
  successCode: string,
  body?: any,
  needToken = true,
) {
  try {
    let accessToken, option;

    if (needToken) {
      accessToken = getAccessToken();
      if (!accessToken) {
        alert('no access token');
        return;
      }
      option = {
        headers: { 'X-AUTH-TOKEN': accessToken },
      };
    }
    let response;

    if (method === 'GET') {
      response = await axios.get(URL.HOST + endpoint, option);
    }

    if (method === 'POST') {
      response = await axios.post(URL.HOST + endpoint, body, option);
    }

    const { code, data, err } = response?.data;
    if (code === successCode) {
      if (data) return data;
      return code;
    }

    if (err) return { err };
  } catch (e: any) {
    if (e.response?.data.code === RESPONSE.TOKEN.EXPIRED) {
      await reissueAPI(); // todo: 예외처리 필요
    } else {
      clearSession();
      return;
    }
  }
}

export default apiHandler;
