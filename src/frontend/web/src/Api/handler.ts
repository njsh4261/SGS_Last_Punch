import axios from 'axios';
import { URL, TOKEN, RESPONSE } from '../constant';
import clearSession from '../util/clearSession';
import reissueAPI from './reissue';

const getAccessToken = () => localStorage.getItem(TOKEN.ACCESS);

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

async function apiHandler(
  method: 'DELETE',
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
    let response;
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
  } catch (e: any) {
    if (e.response?.data.code === RESPONSE.TOKEN.EXPIRED) {
      const reissueResponse = await reissueAPI();
      if (reissueResponse === RESPONSE.SIGNIN.SUCCESS) {
        let response;
        switch (method) {
          case 'GET':
            response = await apiHandler(
              method,
              endpoint,
              successCode,
              needToken,
            );
            break;
          case 'POST':
            response = await apiHandler(
              method,
              endpoint,
              successCode,
              body,
              needToken,
            );
            break;
          case 'PUT':
            response = await apiHandler(
              method,
              endpoint,
              successCode,
              body,
              needToken,
            );
        }
        return response;
      }
    } else {
      clearSession(false);
      return; // return undefined when server error
    }
  }
}

export default apiHandler;
