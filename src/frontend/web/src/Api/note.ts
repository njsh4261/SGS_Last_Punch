import axios from 'axios';
import { RESPONSE, TOKEN, URL } from '../constant';

// const TEST_AWS = 'http://13.125.123.25:9000';
const TEST_LOCAL = 'http://localhost:8080';

const HOST = TEST_LOCAL;

const getAccessToken = () => sessionStorage.getItem(TOKEN.ACCESS);
const accessToken = getAccessToken();

export async function createNoteAPI(
  wsId: number,
  channelId: number,
  creatorId: number,
): Promise<string | undefined> {
  const endpoint = `/note`;
  const body = {
    workspaceId: wsId,
    channelId,
    creatorId,
  };

  if (!accessToken) {
    alert('no token - note api');
    return;
  }
  try {
    const response = await axios.request({
      method: 'POST',
      url: HOST + endpoint,
      data: body,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
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

export async function getNoteListAPI(
  channelId: number,
): Promise<any[] | undefined> {
  const endpoint = `/notes?channelId=${channelId}`;

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'GET',
      url: HOST + endpoint,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });

    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      return data.noteList;
    }
    if (err) alert('fail get note list');
  } catch (e) {
    alert('fail request');
  }
}

export async function getSpecificNoteAPI(
  noteId: string,
): Promise<any | undefined> {
  const endpoint = `/note/${noteId}`;

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'GET',
      url: HOST + endpoint,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });

    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      return data.note;
    }
    if (err) alert('fail get specific note');
  } catch (e) {
    alert('fail request');
  }
}

export async function updateNoteAllAPI(
  noteId: string,
  title: string,
  content: string,
) {
  const endpoint = '/note';
  const body = {
    noteId,
    title,
    content,
    modifyDt: new Date().toISOString(),
  };

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'PUT',
      url: HOST + endpoint,
      data: body,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });
    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      console.log('success update note all');
      if (data) return data;
      return code;
    }
    if (err) alert('fail update note all');
  } catch (e) {
    alert('fail request');
  }
}

/**
 *
 * @param noteId
 * @param op applied JSON.stringfy(op)
 * @returns `timestramp(string)` | `undefined`
 */
export async function updateNoteOPAPI(
  noteId: string,
  op: string,
): Promise<string | undefined> {
  const endpoint = '/note/op';
  const timestamp = new Date().toISOString();
  const body = {
    noteId,
    op,
    timestamp,
  };

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'POST',
      url: HOST + endpoint,
      data: body,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });
    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      console.log('success update note op');
      return timestamp;
    }
    if (err) alert('fail update note op');
  } catch (e) {
    alert('fail request');
  }
}

export async function getNoteOPAPI(noteId: string, timestamp: string) {
  const endpoint = `/note/${noteId}/op?timestamp=${timestamp}`;

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'GET',
      url: HOST + endpoint,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });
    console.log('get response:', response);
    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      console.log('success update note op');
      if (data) return data;
      return code;
    }
    if (err) alert('fail update note op');
  } catch (e) {
    alert('fail request');
  }
}

export async function updateTitleAPI(noteId: string, title: string) {
  const endpoint = '/note/title';
  const body = {
    noteId,
    title,
  };

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'PUT',
      url: HOST + endpoint,
      data: body,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });
    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      console.log('success update title');
      return code;
    }
    if (err) console.error('fail update title');
  } catch (e) {
    alert('fail request - update title');
  }
}

export async function getTitleAPI(noteId: string) {
  const endpoint = `/note/${noteId}/title`;

  if (!accessToken) {
    alert('no token - note api');
    return;
  }

  try {
    const response = await axios.request({
      method: 'GET',
      url: HOST + endpoint,
      headers: {
        'X-AUTH-TOKEN': accessToken,
      },
    });
    const { code, data, err } = response?.data;
    if (code === RESPONSE.NOTE.SUCCESS) {
      console.log('success get title');
      return data;
    }
    if (err) console.error('fail update title');
  } catch (e) {
    alert('fail request - get title');
  }
}
