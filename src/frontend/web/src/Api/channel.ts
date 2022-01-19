import axios from 'axios';
import { HOST, ERROR_MESSAGE } from '../constant';

interface ICreate {
  workspaceId: number;
  creatorId?: number;
  name: string;
  topic?: string;
  description: string;
  settings?: number;
  status?: number;
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

export async function createChannelAPI({
  workspaceId,
  creatorId = 1,
  name,
  topic = 'default',
  description,
  settings = 1,
  status = 2,
}: ICreate) {
  const endpoint = `/channel`;
  const data = {
    workspaceId,
    creatorId,
    name,
    topic,
    description,
    settings,
    status,
  };

  try {
    const response = await axios.post(HOST + endpoint, data);
    if (response.status !== 200) throw new Error(ERROR_MESSAGE.WORKSPACE.LIST);
    return true;
  } catch (e) {
    return false;
  }
}
