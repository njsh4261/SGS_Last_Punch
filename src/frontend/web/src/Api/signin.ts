import axios from 'axios';
import { RESPONSE, ERROR_MESSAGE } from '../constant';

export default async function signinAPI(email: string, pass: string) {
  const host = process.env.REACT_APP_BACKEND_HOST;
  const endpoint = '/auth/login';
  const body = {
    email,
    password: pass,
  };

  try {
    const response = await axios.post(host + endpoint, body);
    const { code, data, err } = response.data;

    if (code === RESPONSE.SIGNIN_SUCCESS) {
      const { access_token, refresh_token } = data;
      sessionStorage.setItem('access_token', access_token);
      sessionStorage.setItem('refresh_token', refresh_token);
      location.href = 'http://localhost:3000';
    }

    if (code === RESPONSE.SIGNIN_FAIL) {
      alert(err.desc);
    }
  } catch (e) {
    alert(ERROR_MESSAGE.SIGNIN.SERVER);
    return;
  }
}
