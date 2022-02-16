import apiHandler from './handler';
import { RESPONSE } from '../constant';

export async function getPresenceAPI(wsId: string | number) {
  const endpoint = `/presence${wsId}`;
  const response = await apiHandler(
    'GET',
    endpoint,
    RESPONSE.WORKSPACE.SUCCESS,
  );
  console.log('presence response:', response);
  return response;
}
