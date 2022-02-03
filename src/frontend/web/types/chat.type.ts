export interface SendMessage {
  sender: string;
  content: string;
  channelId: string;
}

export interface ChatMessage {
  writerId: string;
  text: string;
  profileImg?: string;
}
