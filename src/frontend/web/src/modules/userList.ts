import { UserState } from './user';

const SET_USER_LIST = 'userList/set';

type UserListState = UserState[];

export const setUserList = (userList: UserListState) => ({
  type: SET_USER_LIST,
  userList,
});

type UserListAction = ReturnType<typeof setUserList>;

const intialUserList: any[] = [];

export default function userList(
  state = intialUserList,
  action: UserListAction,
): UserListState {
  switch (action.type) {
    case SET_USER_LIST:
      return [...action.userList];
      break;
    default:
      return state;
  }
}
