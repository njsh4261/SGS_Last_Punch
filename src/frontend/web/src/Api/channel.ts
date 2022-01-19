import axios from 'axios';
import { HOST, ERROR_MESSAGE } from '../constant';

interface ICreate {
  workspaceId: string;
  creatorId: string;
  name: string;
  topic: string;
  description: string;
  settings: number;
  status: number;
}

export async function getChannelInfoAPI(channelId: string) {
  const endpoint = `/channel/${channelId}`;

  try {
    const response = await axios.get(HOST + endpoint);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.LIST);
    return response.data.data;
  } catch (e) {
    return false;
  }
}

export async function createChannelAPI(data: ICreate) {
  const endpoint = `/channel`;

  try {
    const response = await axios.post(HOST + endpoint, data);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.LIST);
    return response.data.data;
  } catch (e) {
    return false;
  }
}
