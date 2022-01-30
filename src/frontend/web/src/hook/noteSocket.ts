import React, { useState, useRef, useEffect, useMemo } from 'react';
import SockJS from 'sockjs-client';
import { CompatClient, Stomp } from '@stomp/stompjs';
import { Editor } from 'slate';

export type Owner = React.MutableRefObject<User | null>;

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
  owner: Owner;
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

const enterAndSub = (props: EnterAndSubProps) => () => {
  const { editor, myUser, userList, stomp, remote, owner, enterNote } = props;

  enterNote(stomp);

  stomp.subscribe(`/user/note/${myUser.id}`, (payload) => {
    const transaction = JSON.parse(payload.body);
    owner.current = transaction.owner;
    userList.current = transaction.userList;
  });

  stomp.subscribe('/sub/note/abcd', (payload) => {
    const transaction = JSON.parse(payload.body);
    switch (transaction.type) {
      case MESSAGE_TYPE.ENTER:
        userList.current.push(transaction.user);
        break;
      case MESSAGE_TYPE.LEAVE:
        userList.current = userList.current.filter(
          (u) => u.id !== transaction.user.id,
        );
        break;
      case MESSAGE_TYPE.LOCK:
        owner.current = transaction.user;
        break;
      case MESSAGE_TYPE.UNLOCK:
        owner.current = null;
        break;
      case MESSAGE_TYPE.UPDATE:
        if (transaction.user.id !== myUser.id) {
          console.log('call API(get op by timestamp)');
          // call API (get ops by 'timestamp')
          // const ops = JSON.parse(transaction.data);
          // if (!ops) return;

          // remote.current = true;
          // Editor.withoutNormalizing(editor, () => {
          //   ops.forEach((op: any) => editor.apply(op));
          // });
        }
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

  // const [stomp, setStomp] = useState<CompatClient>();
  const stomp = useRef<CompatClient>();
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
      stomp.current = stompClient;
    } catch (e) {
      // console.error(e);
      return;
    }
  };

  const disconnect = () => {
    if (stomp.current) {
      leaveNote();
      stomp.current.disconnect();
    }
  };

  const enterNote = () => {
    if (stomp.current) stompSend(stomp.current, MESSAGE_TYPE.ENTER);
  };

  const leaveNote = () => {
    if (stomp.current) stompSend(stomp.current, MESSAGE_TYPE.LEAVE);
  };

  const lockNote = () => {
    if (stomp.current && owner.current === null)
      stompSend(stomp.current, MESSAGE_TYPE.LOCK);
  };

  const unlockNote = () => {
    if (stomp.current && owner.current === myUser)
      stompSend(stomp.current, MESSAGE_TYPE.UNLOCK);
  };

  const updateNote = () => {
    if (stomp.current && owner.current === myUser) {
      const date = new Date();
      const stringDate = date.toJSON();
      stompSend(stomp.current, MESSAGE_TYPE.UPDATE, stringDate);
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
