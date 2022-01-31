import axios from 'axios';
import { RESPONSE } from '../constant';

const testHost = 'http://localhost:9000'; // todo: change

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

export async function getNoteListAPI(
  channelId: number,
): Promise<any[] | undefined> {
  const endpoint = `/notes?channelId=${channelId}`;

  try {
    const response = await axios.request({
      method: 'GET',
      url: testHost + endpoint,
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

  try {
    const response = await axios.request({
      method: 'GET',
      url: testHost + endpoint,
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

  try {
    const response = await axios.request({
      method: 'PUT',
      url: testHost + endpoint,
      data: body,
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

export async function updateNoteOPAPI(noteId: string, op: string) {
  const endpoint = '/note/op';
  const body = {
    noteId,
    op,
    timestamp: new Date().toISOString(),
  };

  try {
    const response = await axios.request({
      method: 'POST',
      url: testHost + endpoint,
      data: body,
    });
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

export async function getNoteOPAPI(noteId: string, timestamp: string) {
  const endpoint = `/note/${noteId}/op?timestamp=${timestamp}`;

  try {
    const response = await axios.request({
      method: 'GET',
      url: testHost + endpoint,
    });
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
