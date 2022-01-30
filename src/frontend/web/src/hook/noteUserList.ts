import { useState, useEffect } from 'react';
import { User, UserList } from './noteSocket';

interface HookProps {
  userList: UserList;
}
interface HookReturns {
  userListState: User[];
}

export default function noteUserListHook(props: HookProps): HookReturns {
  const { userList } = props;
  const [userListState, setUserListState] = useState<User[]>([]);
  useEffect(() => {
    setUserListState(userList.current);
  }, userList.current);
  return { userListState };
}
