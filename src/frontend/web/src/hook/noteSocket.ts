import React, { useState, useRef, useEffect, useMemo } from 'react';
import SockJS from 'sockjs-client';
import { CompatClient, Stomp } from '@stomp/stompjs';
import { Editor } from 'slate';
import { HistoryEditor } from 'slate-history';
import { ReactEditor } from 'slate-react';

const getEnterMessage = (userId: number) => ({
  type: 'ENTER',
  noteId: 'abcd',
  data: 'hello test',
  userId,
});

const getUpdateMessage = (op: any, userId: number) => ({
  type: 'UPDATE',
  noteId: 'abcd',
  data: JSON.stringify(op),
  userId,
});

const enterAndSub =
  (
    editor: Editor,
    userId: number,
    stompClient: CompatClient,
    remote: React.MutableRefObject<boolean>,
  ) =>
  () => {
    stompClient.send('/pub/note', {}, JSON.stringify(getEnterMessage(userId)));

    stompClient.subscribe('/sub/note/abcd', (payload) => {
      const transacrtion = JSON.parse(payload.body);

      if (transacrtion.userId === userId) return;
      if (transacrtion.type !== 'UPDATE') return;

      const ops = JSON.parse(transacrtion.data);
      if (!ops) return;

      remote.current = true;
      Editor.withoutNormalizing(editor, () => {
        ops.forEach((op: any) => editor.apply(op));
      });
    });
  };

export default function noteSocketHook(
  editor: Editor,
): [sendMessage: (ops: any) => void, remote: React.MutableRefObject<boolean>] {
  // todo: crrect userId
  const userId = useMemo(() => Math.floor(Math.random() * 9999), []);
  const [stomp, setStomp] = useState<CompatClient>();
  const remote = useRef(false);

  const connect = () => {
    const url = 'http://localhost:9001/ws/note';
    const socket = new SockJS(url);
    const stompClient = Stomp.over(socket);
    stompClient.connect({}, enterAndSub(editor, userId, stompClient, remote));
    setStomp(stompClient);
  };

  const disconnect = () => stomp?.disconnect();

  const sendMessage = (ops: any) => {
    stomp?.send('/pub/note', {}, JSON.stringify(getUpdateMessage(ops, userId)));
  };

  useEffect(() => {
    connect();
    return disconnect;
  }, []);

  return [sendMessage, remote];
}
