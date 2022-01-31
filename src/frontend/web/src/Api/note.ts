import axios from 'axios';
import { RESPONSE } from '../constant';

/**
 *
 * @param wsId
 * @param channelId
 * @returns `noteId` | `undefined`
 */
export async function createNoteAPI(
  wsId: number,
  channelId: number,
  creatorId: number,
) {
  const testHost = 'http://localhost:9000'; // todo: change
  const endpoint = `/note`;
  const body = {
    workspaceId: wsId,
    channelId,
    creatorId,
  };

  try {
    const response = await axios.request({
      method: 'POST',
      url: testHost + endpoint,
      data: body,
    });

    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      alert('success create note');
      return data.noteId;
    }
    if (err) alert('fail create note');
  } catch (e) {
    alert('fail request');
  }
}
