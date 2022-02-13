import axios from 'axios';
import { URL, TOKEN, RESPONSE } from '../constant';
import logout from '../util/logout';
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
  body?: any, // POST, PUT
  needToken = true, // 토큰이 필요한 API 유형인지
) {
  try {
    let accessToken, option, response;

    if (needToken) {
      accessToken = getAccessToken();
      // 토큰이 필요한 API인데 토큰이 없는 경우
      if (!accessToken) {
        logout();
        return;
      }
      option = {
        headers: { 'X-AUTH-TOKEN': accessToken },
      };
    }

    switch (method) {
      case 'GET':
        response = await axios.get(URL.HOST + endpoint, option);
        break;
      case 'POST':
        response = await axios.post(URL.HOST + endpoint, body, option);
        break;
      case 'PUT':
        response = await axios.put(URL.HOST + endpoint, body, option);
        break;
      case 'DELETE':
        response = await axios.delete(URL.HOST + endpoint, option);
        break;
    }

    const { code, data, err } = response?.data;
    if (code === successCode) {
      if (data) return data;
      return code;
    }

    if (err) return { err };
    else console.error('wrong response code');
  } catch (e: any) {
    // access 토큰이 만료된 경우 reissueAPI를 통해 재발급
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
      logout();
      return; // return undefined when server error
    }
  }
}

export default apiHandler;
