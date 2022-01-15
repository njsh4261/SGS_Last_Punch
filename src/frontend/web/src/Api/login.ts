import axios from 'axios';

export default async function loginAPI(email: string, pass: string) {
  const host = process.env.REACT_APP_BACKEND_HOST;
  const endpoint = '/auth/login';
  const data = {
    email,
    password: pass,
  };
  try {
    const response = await axios.post(host + endpoint, data);
    if (response.status !== 200) throw new Error('login fail');
    return response.data;
  } catch (e) {
    return false;
  }
}
