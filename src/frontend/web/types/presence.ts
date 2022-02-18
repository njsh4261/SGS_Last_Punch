export type UserStatus =
  | 'CONNECT'
  | 'ONLINE'
  | 'ABSENT'
  | 'BUSY'
  | 'OFFLINE'
  | 'DISCONNECT';

export type UpdateMessage = {
  workspaceId: string;
  userId: string;
  userStatus: UserStatus;
};
