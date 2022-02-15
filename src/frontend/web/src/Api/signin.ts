import axios from 'axios';
import Swal from 'sweetalert2';

import { RESPONSE, ERROR_MESSAGE, URL, ENDPOINT, TOKEN } from '../constant';

export default async function signinAPI(email: string, pass: string) {
  const host = process.env.REACT_APP_BACKEND_HOST;
  const endpoint = ENDPOINT.SIGNIN;
  const body = {
    email,
    password: pass,
  };

  try {
    const response = await axios.post(host + endpoint, body);
    const { code, data, err } = response.data;

    // 로그인 성공: localStorage에 token 저장 후 url 변경
    if (code === RESPONSE.SIGNIN.SUCCESS) {
      const { access_token, refresh_token } = data;
      localStorage.setItem(TOKEN.ACCESS, access_token);
      localStorage.setItem(TOKEN.REFRESH, refresh_token);
      if (URL.REDIRECT_HOME) location.href = URL.REDIRECT_HOME;
    }

    // 로그인 실패
    if (code === RESPONSE.SIGNIN.FAIL) {
      Swal.fire(err.desc, '', 'error');
    }
  } catch (e) {
    // 요청 실패
    alert(ERROR_MESSAGE.SERVER);
    return;
  }
}
