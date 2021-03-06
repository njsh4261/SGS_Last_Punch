export interface IWorkspace {
  id: number; // todo: 바뀔수 있음
  name: string;
  description: string | null;
  createDt: string;
  imageNum: number | null;
  owner: {
    id: number;
    name: string;
  };
}

export interface ICreateWs {
  workspaceName: string;
  channelName: string;
}

export interface IMemberInWS {
  id: number;
  name: string;
  lastMessage: {
    authorId: number;
    channelId: number;
    content: string;
    id: number;
    createDt: any;
    modifyDt: any;
    status: any;
  };
}
