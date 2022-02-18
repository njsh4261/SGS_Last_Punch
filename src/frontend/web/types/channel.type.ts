export interface IChannel {
  id: number;
  name: string;
  workspaceId: number;
  creator: any;
  topic: string;
  status: number;
  settings: number;
  description: string;
  createDt: string;
  owner: {
    id: number;
    name: string;
  };
}

export interface ICreateChannel {
  workspaceId: number;
  name: string;
  topic?: string;
  description: string;
}
