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

    if (code === RESPONSE.SIGNIN_SUCCESS) {
      const { access_token, refresh_token } = data;
      sessionStorage.setItem(TOKEN.ACCESS, access_token);
      sessionStorage.setItem(TOKEN.REFRESH, refresh_token);
      console.log(URL.REDIRECT_HOME);
      location.href = URL.REDIRECT_HOME;
    }

    if (code === RESPONSE.SIGNIN_FAIL) {
      alert(err.desc);
    }
  } catch (e) {
    alert(ERROR_MESSAGE.SIGNIN.SERVER);
    return;
  }
}
