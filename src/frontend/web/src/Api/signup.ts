import axios from 'axios';

export default async function signupAPI(email: string, pass: string) {
  const host = process.env.REACT_APP_BACKEND_HOST;
  const endpoint = '/auth/signup';
  const data = {
    email,
    password: pass,
  };
  try {
    const response = await axios.post(host + endpoint, data);
    if (response.status !== 200) throw new Error('signup fail');
    return true;
  } catch (e) {
    return false;
  }
}
