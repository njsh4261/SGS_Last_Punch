export interface SendMessage {
  authorId: string;
  channelId: string;
  content: string;
}

export interface ChatMessage {
  id: string;
  authorId: string;
  channelId: string;
  content: string;
  status: number;
  createDt: Date;
  modifyDt: Date;
  profileImg?: string;
}
