import { RESPONSE } from '../constant';
import apiHandler from './handler';

export async function getSelfInfoAPI() {
  const endpoint = `/account/self`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  return response;
}

export async function searchMemberAPI(email: string) {
  const endpoint = `/account/find?page=0&size=999`; // dummy size
  const body = {
    email,
  };
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
    body,
  );
  return response?.accounts.content;
}
