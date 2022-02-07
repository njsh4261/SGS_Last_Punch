const SET_USER = 'user/set';

export type UserState = {
  id: number;
  name: string;
};

export const setUser = ({ id, name }: UserState) => ({
  type: SET_USER,
  id,
  name,
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
      };
      break;
    default:
      return state;
  }
}
