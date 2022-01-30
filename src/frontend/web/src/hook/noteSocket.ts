import React, { useState, useRef, useEffect, useMemo } from 'react';
import SockJS from 'sockjs-client';
import { CompatClient, Stomp } from '@stomp/stompjs';
import { Editor } from 'slate';

export type User = {
  id: number;
  name: string;
};

export type UserList = React.MutableRefObject<User[]>;

enum MESSAGE_TYPE {
  ENTER = 'ENTER',
  LEAVE = 'LEAVE',
  UPDATE = 'UPDATE',
  LOCK = 'LOCK',
  UNLOCK = 'UNLOCK',
}

interface EnterAndSubProps {
  editor: Editor;
  myUser: User;
  userList: UserList;
  stomp: CompatClient;
  remote: React.MutableRefObject<boolean>;
  owner: React.MutableRefObject<User | null>;
  enterNote: (stomp: CompatClient) => void;
}

interface HookReturns {
  updateNote: () => void;
  remote: React.MutableRefObject<boolean>;
  lockNote: () => void;
  unlockNote: () => void;
  owner: React.MutableRefObject<User | null>;
  myUser: User;
  userList: UserList;
}

const enterAndSub =
  ({
    editor,
    myUser,
    userList,
    stomp,
    remote,
    owner,
    enterNote,
  }: EnterAndSubProps) =>
  () => {
    enterNote(stomp);

    stomp.subscribe('/sub/note/abcd', (payload) => {
      const transacrtion = JSON.parse(payload.body);
      switch (transacrtion.type) {
        case MESSAGE_TYPE.ENTER:
          userList.current.push(transacrtion.user);
          break;
        case MESSAGE_TYPE.LEAVE:
          userList.current = userList.current.filter(
            (u) => u.id !== transacrtion.user.id,
          );
          break;
        case MESSAGE_TYPE.LOCK:
          owner.current = transacrtion.user;
          break;
        case MESSAGE_TYPE.UNLOCK:
          owner.current = null;
          break;
        case MESSAGE_TYPE.UPDATE:
          if (transacrtion.user.id !== myUser.id) {
            console.log('call API(get op by timestamp)');
            // call API (get ops by 'timestamp')
            // const ops = JSON.parse(transacrtion.data);
            // if (!ops) return;

            // remote.current = true;
            // Editor.withoutNormalizing(editor, () => {
            //   ops.forEach((op: any) => editor.apply(op));
            // });
          }
          break;
        case '현재 노트 상황':
          owner.current = transacrtion.owner;
          userList.current = transacrtion.userList;
          break;
        default:
          console.error('wrong type');
      }
    });
  };

export default function noteSocketHook(editor: Editor): HookReturns {
  // dummy user data
  const myUser = useMemo(
    () => ({
      id: Math.floor(Math.random() * 9999),
      name: 'test user myUserame ' + Math.floor(Math.random() * 9999),
    }),
    [],
  );

  const [stomp, setStomp] = useState<CompatClient>();
  const remote = useRef(false);
  const owner = useRef<User | null>(null); // userId
  const userList = useRef<User[]>([]);

  const connect = () => {
    const url = 'http://localhost:9001/ws/note';
    try {
      const socket = new SockJS(url);
      const stompClient = Stomp.over(socket);
      stompClient.connect(
        {},
        enterAndSub({
          editor,
          myUser,
          userList,
          stomp: stompClient,
          remote,
          owner,
          enterNote,
        }),
      );
      setStomp(stompClient);
    } catch (e) {
      // console.error(e);
      return;
    }
  };

  const disconnect = () => {
    leaveNote();
    stomp?.disconnect();
  };

  const enterNote = () => {
    if (stomp) stompSend(stomp, MESSAGE_TYPE.ENTER);
  };

  const leaveNote = () => {
    if (stomp) stompSend(stomp, MESSAGE_TYPE.LEAVE);
  };

  const lockNote = () => {
    if (stomp && owner.current === null) stompSend(stomp, MESSAGE_TYPE.LOCK);
  };

  const unlockNote = () => {
    if (stomp && owner.current === myUser)
      stompSend(stomp, MESSAGE_TYPE.UNLOCK);
  };

  const updateNote = () => {
    if (stomp && owner.current === myUser) {
      const stringDate = JSON.stringify(new Date());
      stompSend(stomp, MESSAGE_TYPE.UPDATE, stringDate);
    }
  };

  // const sendOps = (ops: any) => {
  //   if (owner.current !== userId) return;
  //   try {
  //     stomp?.send(
  //       '/pub/note',
  //       {},
  //       JSON.stringify(getUpdateMessage(ops, userId, userName)),
  //     );
  //   } catch (e) {
  //     // console.error(e);
  //     return;
  //   }
  // };

  const stompSend = (
    stomp: CompatClient,
    type: MESSAGE_TYPE,
    timestamp?: string, // todo: change date
  ) => {
    try {
      stomp.send(
        '/pub/note',
        {},
        JSON.stringify({
          type: type,
          noteId: 'abcd',
          myUser,
          timestamp,
        }),
      );
    } catch (e) {
      console.error(e);
      return;
    }
  };

  useEffect(() => {
    connect();
    return disconnect;
  }, []);

  return { updateNote, remote, lockNote, unlockNote, owner, myUser, userList };
}
