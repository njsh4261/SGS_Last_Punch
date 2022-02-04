import axios from 'axios';
import { URL, ERROR_MESSAGE, TOKEN, RESPONSE } from '../constant';
import clearSession from '../util/clearSession';
import reissueAPI from './reissue';

const getAccessToken = () => localStorage.getItem(TOKEN.ACCESS);

const AxiosRequest = async (
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  endpoint: string,
  successCode: string,
  body?: any,
) => {
  let response;
  const option = {
    headers: { 'X-AUTH-TOKEN': getAccessToken()! },
  };

  switch (method) {
    case 'GET':
      response = await axios.get(URL.HOST + endpoint, option);
      break;
    case 'POST':
      response = await axios.post(URL.HOST + endpoint, body, option);
      break;
    case 'PUT':
      response = await axios.put(URL.HOST + endpoint, body, option);
  }

  const { code, data, err } = response?.data;
  if (code === successCode) {
    if (data) return data;
    return code;
  }

  if (err) return { err };
  else console.error('wrong response code');
};

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

async function apiHandler(
  method: 'PUT',
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
        clearSession();
        return;
      }
      option = {
        headers: { 'X-AUTH-TOKEN': accessToken },
      };
    }
    return AxiosRequest(method, endpoint, successCode, body);
  } catch (e: any) {
    if (e.response?.data.code === RESPONSE.TOKEN.EXPIRED) {
      const reissueResponse = await reissueAPI();
      if (reissueResponse === RESPONSE.SIGNIN.SUCCESS) {
        return AxiosRequest(method, endpoint, successCode, body);
      }
    } else {
      clearSession(false);
      return; // return undefined when server error
    }
  }
}

export default apiHandler;
