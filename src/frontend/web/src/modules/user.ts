const SET_USER = 'user/set';
import { UserStatus } from '../../types/presence';

export type UserState = {
  id: number;
  name: string;
  imageNum: number | null;
  lastMessage?: any;
  alarm?: boolean;
  status?: UserStatus;
};

export const setUser = ({ id, name, status, imageNum }: UserState) => ({
  type: SET_USER,
  id,
  name,
  status,
  imageNum,
});

type UserAction = ReturnType<typeof setUser>;

const initialUser = {
  id: 0,
  name: '',
  imageNum: null,
};

export default function user(
  state: UserState = initialUser,
  action: UserAction,
): UserState {
  switch (action.type) {
    case SET_USER:
      return {
        id: action.id,
        name: action.name,
        status: action.status,
        imageNum: action.imageNum,
      };
    default:
      return state;
  }
}
