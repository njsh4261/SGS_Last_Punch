export interface SendMessage {
  authorId: string;
  channelId: string;
  content?: string;
  type?: 'MESSAGE' | 'TYPING';
}

export interface ChatMessage {
  id: string;
  authorId: string;
  channelId: string;
  content: string;
  status: number;
  createDt: string;
  modifyDt: Date;
  profileImg?: string;
}
