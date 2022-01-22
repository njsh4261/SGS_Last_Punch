import axios from 'axios';
import { ERROR_MESSAGE } from '../constant';

export default async function signinAPI(email: string, pass: string) {
  const host = process.env.REACT_APP_BACKEND_HOST;
  const endpoint = '/auth/login';
  const data = {
    email,
    password: pass,
  };
  try {
    const response = await axios.post(host + endpoint, data);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.SIGNIN.WRONG);
    return response.data;
  } catch (e) {
    return false;
  }
}
