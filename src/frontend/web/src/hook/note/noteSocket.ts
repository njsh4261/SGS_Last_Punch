import React, {
  useState,
  useRef,
  useEffect,
  useMemo,
  SetStateAction,
} from 'react';
import SockJS from 'sockjs-client';
import { CompatClient, Stomp } from '@stomp/stompjs';
import { Editor } from 'slate';

import { getNoteOPAPI, getTitleAPI } from '../../Api/note';
import { Note } from '../../../types/note.type';
import { TOKEN, URL } from '../../constant';

// const TEST_AWS = 'http://13.125.123.25:9001/ws/note';
const TEST_LOCAL = 'http://localhost:9001/ws/note';

const HOST = 'http://localhost:8080/ws/note';

export type User = {
  id: number;
  name: string;
};

enum MESSAGE_TYPE {
  ENTER = 'ENTER',
  LEAVE = 'LEAVE',
  UPDATE = 'UPDATE',
  UPDATE_TITLE = 'UPDATE_TITLE',
  LOCK = 'LOCK',
  UNLOCK = 'UNLOCK',
}

interface EnterAndSubProps {
  editor: Editor;
  myUser: User;
  note: Note | null;
  setUserList: React.Dispatch<SetStateAction<User[]>>;
  stomp: CompatClient;
  owner: User | null;
  setOwner: React.Dispatch<SetStateAction<User | null>>;
  enterNote: (stomp: CompatClient) => void;
  setTitle: React.Dispatch<SetStateAction<string>>;
}

interface HookReturns {
  updateNote: (timestamp: string) => void;
  updateTitle: () => void;
  lockNote: () => void;
  unlockNote: () => void;
  leaveNote: () => void;
  owner: User | null;
  myUser: User;
  userList: User[];
  title: string;
  setTitle: React.Dispatch<SetStateAction<string>>;
}

const enterAndSub = (props: EnterAndSubProps) => () => {
  const {
    editor,
    myUser,
    note,
    setUserList,
    stomp,
    owner,
    setOwner,
    enterNote,
    setTitle,
  } = props;

  enterNote(stomp);

  stomp.subscribe(`/user/note/${myUser.id}`, (payload) => {
    console.log('접속 성공');
    const transaction = JSON.parse(payload.body);
    if (transaction.owner) setOwner(JSON.parse(transaction.owner));
    setUserList(transaction.userList.map((u: string) => JSON.parse(u)));
  });

  stomp.subscribe(`/sub/note/${note!.id}`, async (payload) => {
    const transaction = JSON.parse(payload.body);

    switch (transaction.type) {
      case MESSAGE_TYPE.ENTER:
        if (transaction.myUser.id !== myUser.id) {
          console.log('someone enter');
          setUserList((ul) => [...ul, transaction.myUser]);
        }
        break;
      case MESSAGE_TYPE.LEAVE:
        console.log('leave');
        setUserList((ul) => ul.filter((u) => u.id !== transaction.myUser.id));
        break;
      case MESSAGE_TYPE.LOCK:
        // test
        console.log('lock:', transaction.myUser, myUser);
        setOwner(transaction.myUser);
        break;
      case MESSAGE_TYPE.UNLOCK:
        console.log('unlock');
        setOwner(null);
        break;
      case MESSAGE_TYPE.UPDATE_TITLE:
        const data = await getTitleAPI(note!.id);
        if (data) {
          console.log(data);
          // setTitle(data);
        }
        break;
      case MESSAGE_TYPE.UPDATE:
        if (transaction.myUser.id !== myUser.id) {
          const { noteId, timestamp } = transaction;
          const data = await getNoteOPAPI(noteId.toString(), timestamp);
          if (!data) {
            console.error('fail get operations - hook/noteSocket');
            return;
          }

          try {
            const ops = JSON.parse(data.op);
            Editor.withoutNormalizing(editor, () => {
              ops.forEach((op: any) => editor.apply(op));
            });
          } catch (e) {
            console.error(e);
          }
        }
        break;
      default:
        console.error('wrong type - fail apply updated');
    }
  });
};

export default function noteSocketHook(
  editor: Editor,
  note: Note | null,
): HookReturns {
  // dummy user data
  const myUser = useMemo(
    () => ({
      id: Math.floor(Math.random() * 9999999),
      name: 'test user myUserame ' + Math.floor(Math.random() * 9999),
    }),
    [],
  );

  // const [stomp, setStomp] = useState<CompatClient>();
  const stomp = useRef<CompatClient>();
  const [title, setTitle] = useState('test title');
  const [owner, setOwner] = useState<User | null>(null);
  const [userList, setUserList] = useState<User[]>([]);

  const connect = () => {
    const accessToken = sessionStorage.getItem(TOKEN.ACCESS);
    if (!accessToken || !HOST) {
      console.error('fail connect socket - hook/noteSock');
      return;
    }
    try {
      const socket = new SockJS(HOST);
      const stompClient = Stomp.over(socket);
      stompClient.connect(
        { Authorization: accessToken },
        enterAndSub({
          editor,
          myUser,
          note,
          setUserList,
          stomp: stompClient,
          owner,
          setOwner,
          enterNote,
          setTitle,
        }),
      );
      stomp.current = stompClient;
    } catch (e) {
      console.error(e);
      return;
    }
  };

  const leaveNote = () => {
    if (stomp.current) {
      // stompSend(stomp.current, MESSAGE_TYPE.UNLOCK);
      // stompSend(stomp.current, MESSAGE_TYPE.LEAVE);
      stomp.current.disconnect();
    }
  };

  const enterNote = () => {
    if (stomp.current) stompSend(stomp.current, MESSAGE_TYPE.ENTER);
  };

  const lockNote = () => {
    console.log('reqeust rock, owner=', owner);
    if (stomp.current && owner === null)
      stompSend(stomp.current, MESSAGE_TYPE.LOCK);
  };

  const unlockNote = () => {
    if (stomp.current && owner?.id === myUser.id) {
      stompSend(stomp.current, MESSAGE_TYPE.UNLOCK);
    }
  };

  const updateTitle = () => {
    if (stomp.current && owner?.id === myUser.id) {
      stompSend(stomp.current, MESSAGE_TYPE.UPDATE_TITLE);
    }
  };

  const updateNote = (timestamp: string) => {
    if (stomp.current && owner?.id === myUser.id) {
      stompSend(stomp.current, MESSAGE_TYPE.UPDATE, timestamp);
    }
  };

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
          noteId: note!.id,
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
    if (note) {
      connect();
      return leaveNote;
    }
  }, [note]);

  return {
    updateNote,
    updateTitle,
    lockNote,
    unlockNote,
    leaveNote,
    owner,
    myUser,
    userList,
    title,
    setTitle,
  };
}
