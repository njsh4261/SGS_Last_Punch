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
import { useSelector } from 'react-redux';
import { RootState } from '../../modules';

export type User = RootState['user'];

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
  user: User;
  userList: User[];
  title: string;
  setTitle: React.Dispatch<SetStateAction<string>>;
}

// 소켓 연결시 수행되는 로직. 소켓에 enter 메시지를 보내고 subscribe한다.
const enterAndSub = (props: EnterAndSubProps) => () => {
  const {
    editor,
    myUser,
    note,
    setUserList,
    stomp,
    setOwner,
    enterNote,
    setTitle,
  } = props;

  // publish 'Enter'
  enterNote(stomp);

  // 처음 접속 시에 받는 정보 (선점자, 유저 리스트)
  stomp.subscribe(`/user/note/${myUser.id}`, (payload) => {
    const transaction = JSON.parse(payload.body);
    if (transaction.owner) setOwner(JSON.parse(transaction.owner));
    setUserList(transaction.userList.map((u: string) => JSON.parse(u)));
  });

  // 실시간 업데이트를 위한 구독
  stomp.subscribe(`/sub/note/${note!.id}`, async (payload) => {
    const transaction = JSON.parse(payload.body);

    switch (transaction.type) {
      case MESSAGE_TYPE.ENTER:
        if (transaction.myUser.id !== myUser.id) {
          setUserList((ul) => [...ul, transaction.myUser]);
        }
        break;
      case MESSAGE_TYPE.LEAVE:
        setUserList((ul) => ul.filter((u) => u.id !== transaction.myUser.id));
        break;
      case MESSAGE_TYPE.LOCK:
        setOwner(transaction.myUser);
        break;
      case MESSAGE_TYPE.UNLOCK:
        setOwner(null);
        break;
      case MESSAGE_TYPE.UPDATE_TITLE:
        const data = await getTitleAPI(note!.id);
        if (data.title) {
          setTitle(data.title);
        }
        break;
      case MESSAGE_TYPE.UPDATE:
        if (transaction.myUser.id !== myUser.id) {
          const { noteId, timestamp } = transaction;
          // 특정 시점의 op를 가져옴
          const data = await getNoteOPAPI(noteId.toString(), timestamp);
          if (!data) {
            console.error('fail get operations - hook/noteSocket');
            return;
          }

          try {
            // op를 slate editor에 적용
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
  const user = useSelector((state: RootState) => state.user);

  const stomp = useRef<CompatClient>();
  const [title, setTitle] = useState('test title');
  const [owner, setOwner] = useState<User | null>(null);
  const [userList, setUserList] = useState<User[]>([]);

  const connect = () => {
    const accessToken = localStorage.getItem(TOKEN.ACCESS);
    if (!accessToken || !URL.HOST) {
      console.error('fail connect socket - hook/noteSock');
      return;
    }
    try {
      const socket = new SockJS(URL.HOST + '/ws/note');
      const stompClient = Stomp.over(socket);
      stompClient.debug = (f) => f;
      stompClient.connect(
        { Authorization: accessToken },
        enterAndSub({
          editor,
          myUser: user,
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
      stomp.current.disconnect();
    }
  };

  const enterNote = () => {
    if (stomp.current) stompSend(stomp.current, MESSAGE_TYPE.ENTER);
  };

  const lockNote = () => {
    if (stomp.current && owner === null)
      stompSend(stomp.current, MESSAGE_TYPE.LOCK);
  };

  const unlockNote = () => {
    if (stomp.current && owner?.id === user.id) {
      stompSend(stomp.current, MESSAGE_TYPE.UNLOCK);
    }
  };

  const updateTitle = () => {
    if (stomp.current && owner?.id === user.id) {
      stompSend(stomp.current, MESSAGE_TYPE.UPDATE_TITLE);
    }
  };

  const updateNote = (timestamp: string) => {
    if (stomp.current && owner?.id === user.id) {
      stompSend(stomp.current, MESSAGE_TYPE.UPDATE, timestamp);
    }
  };

  // publish message
  const stompSend = (
    stomp: CompatClient,
    type: MESSAGE_TYPE,
    timestamp?: string,
  ) => {
    try {
      stomp.send(
        '/pub/note',
        {},
        JSON.stringify({
          type: type,
          noteId: note!.id,
          myUser: user,
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
    user,
    userList,
    title,
    setTitle,
  };
}
