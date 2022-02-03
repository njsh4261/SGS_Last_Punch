import axios from 'axios';
import { RESPONSE } from '../constant';
import apiHandler from './handler';

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
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.NOTE.SUCCESS,
    body,
  );
  return response.noteId;
}

export async function getNoteListAPI(
  channelId: number,
): Promise<any[] | undefined> {
  const endpoint = `/notes?channelId=${channelId}`;
  const response = await apiHandler('GET', endpoint, RESPONSE.NOTE.SUCCESS);
  return response.noteList;
}

export async function getSpecificNoteAPI(
  noteId: string,
): Promise<any | undefined> {
  const endpoint = `/note/${noteId}`;
  const response = await apiHandler('GET', endpoint, RESPONSE.NOTE.SUCCESS);
  return response.note;
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

  const response = await apiHandler(
    'PUT',
    endpoint,
    RESPONSE.NOTE.SUCCESS,
    body,
  );
  return response;
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
  const response = await apiHandler(
    'POST',
    endpoint,
    RESPONSE.NOTE.SUCCESS,
    body,
  );
  if (response) return timestamp;
}

export async function getNoteOPAPI(noteId: string, timestamp: string) {
  const endpoint = `/note/${noteId}/op?timestamp=${timestamp}`;
  const response = await apiHandler('GET', endpoint, RESPONSE.NOTE.SUCCESS);
  return response;
}

export async function updateTitleAPI(noteId: string, title: string) {
  const endpoint = '/note/title';
  const body = {
    noteId,
    title,
  };
  const response = await apiHandler(
    'PUT',
    endpoint,
    RESPONSE.NOTE.SUCCESS,
    body,
  );
  return response;
}

export async function getTitleAPI(noteId: string) {
  const endpoint = `/note/${noteId}/title`;
  const response = await apiHandler('GET', endpoint, RESPONSE.NOTE.SUCCESS);
  return response;
}
