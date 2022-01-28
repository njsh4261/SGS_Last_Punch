import { useState, useEffect } from 'react';
import SockJS from 'sockjs-client';
import { CompatClient, Stomp } from '@stomp/stompjs';

export default function noteSocketHook(): [sendMessage: (msg: any) => void] {
  const [stomp, setStomp] = useState<CompatClient>();

  const connect = () => {
    const url = 'http://localhost:9001/ws/note';
    const ENTER_MSG = {
      type: 'ENTER',
      noteId: 'abcd',
      data: 'hello test',
      userId: 1,
    };
    const socket = new SockJS(url);
    const stompClient = Stomp.over(socket);
    stompClient.connect({}, (frame: any) => {
      console.log('Connected: ' + frame);
      stompClient.send('pub/note', {}, JSON.stringify(ENTER_MSG));
      stompClient.subscribe('/sub/note/abcd', (payload) =>
        console.log(payload),
      );
    });
    setStomp(stompClient);
  };

  const disconnect = () => stomp?.disconnect();

  const sendMessage = (msg: string) => {
    const SEND_MSG = {
      type: 'UPDATE',
      noteID: 'abcd',
      data: msg,
    };
    stomp?.send('/pub/note', {}, JSON.stringify(SEND_MSG));
  };

  useEffect(() => {
    connect();

    return disconnect;
  }, []);

  return [sendMessage];
}
