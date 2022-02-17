const SET_USER = 'user/set';
import { UserStatus } from '../../types/presence';

export type UserState = {
  id: number;
  name: string;
  lastMessage?: any;
  alarm?: boolean;
  status?: UserStatus;
};

export const setUser = ({ id, name, status }: UserState) => ({
  type: SET_USER,
  id,
  name,
  status,
});

type UserAction = ReturnType<typeof setUser>;

const initialUser = {
  id: 0,
  name: '',
};

export default function user(
  state = initialUser,
  action: UserAction,
): UserState {
  switch (action.type) {
    case SET_USER:
      return {
        id: action.id,
        name: action.name,
        status: action.status,
      };
    default:
      return state;
  }
}
