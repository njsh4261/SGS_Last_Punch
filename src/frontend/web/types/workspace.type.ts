export interface IWorkspace {
  id: number; // todo: 바뀔수 있음
  name: string;
  description: string | null;
  setting: number;
  status: number;
}

export interface ICreateWs {
  workspaceName: string;
  channelName: string;
}
