import axios from 'axios';
import { URL, TOKEN, ENDPOINT, RESPONSE } from '../constant';

export default async function reissueAPI() {
  const refreshToken = localStorage.getItem(TOKEN.REFRESH);
  if (!refreshToken) {
    console.error('no refresh token');
    return;
  }
  try {
    const response = await axios.get(URL.HOST + ENDPOINT.REISSUE, {
      headers: {
        'X-AUTH-TOKEN': refreshToken,
      },
    });
    if (!response) return;
    if (response.data.code === RESPONSE.SIGNIN.SUCCESS) {
      localStorage.setItem(TOKEN.ACCESS, response.data.data.access_token);
      return response.data.code;
    }
  } catch (e) {
    return;
  }
}
