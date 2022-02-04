import apiHandler from './handler';
import { ENDPOINT, RESPONSE } from '../constant';

export async function duplicateAPI(email: string) {
  const body = { email };
  const response = await apiHandler(
    'POST',
    ENDPOINT.DUPLICATE,
    RESPONSE.SIGNIN.SUCCESS,
    body,
    false,
  );
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
  return response;
}

export async function verifyAPI(email: string, verifyCode: string) {
  const body = { email, verifyCode };
  const response = await apiHandler(
    'POST',
    ENDPOINT.VERIFY,
    RESPONSE.SIGNIN.SUCCESS,
    body,
    false,
  );
  return response;
}

export async function signupAPI(
  email: string,
  displayName: string,
  pass: string,
  verifyCode: string,
) {
  const body = {
    email,
    displayName,
    password: pass,
    verifyCode,
  };
  const response = await apiHandler(
    'POST',
    ENDPOINT.SIGNUP,
    RESPONSE.SIGNIN.SUCCESS,
    body,
    false,
  );
  return response;
}
