import axios from 'axios';
import apiHandler from './handler';
import { URL, ENDPOINT, RESPONSE } from '../constant';

export async function duplicateAPI(email: string) {
  const body = { email };
  const response = await apiHandler(
    'POST',
    ENDPOINT.DUPLICATE,
    RESPONSE.SIGNIN.SUCCESS,
    body,
    false,
  );
  if (response.err) {
    // err: msg, desc
    return response.err.msg;
  }
  return response;
}

export async function sendAPI(email: string) {
  const body = { email };
  const response = await apiHandler(
    'POST',
    ENDPOINT.SEND_EMAIL,
    RESPONSE.SIGNIN.SUCCESS,
    body,
    false,
  );
  if (response.err) {
    return response.err.msg;
  }
  return response;
}

export async function verifyAPI(email: string, verifyCode: string) {
  const body = { email, verifyCode };
  try {
    const response = await axios.post(URL.HOST + ENDPOINT.VERIFY, body);
    return response;
  } catch (e) {
    return;
  }
}

export async function signupAPI(
  email: string,
  pass: string,
  verifyCode: string,
) {
  const body = {
    email,
    password: pass,
    verifyCode,
  };
  try {
    const response = await axios.post(URL.HOST + ENDPOINT.SIGNUP, body);
    console.log(response);
    if (response.status !== 200) throw new Error('signup fail');
    return true;
  } catch (e) {
    return false;
  }
}
