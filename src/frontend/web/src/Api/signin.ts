import axios from 'axios';
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

    if (code === RESPONSE.SIGNIN.SUCCESS) {
      const { access_token, refresh_token } = data;
      localStorage.setItem(TOKEN.ACCESS, access_token);
      localStorage.setItem(TOKEN.REFRESH, refresh_token);
      location.href = URL.REDIRECT_HOME;
    }

    if (code === RESPONSE.SIGNIN.FAIL) {
      alert(err.desc);
    }
  } catch (e) {
    alert(ERROR_MESSAGE.SERVER);
    return;
  }
}
