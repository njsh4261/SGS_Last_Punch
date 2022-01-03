package com.lastpunch.chatproto.dto;

import lombok.Data;

@Data
public class ChatMessage {
    public enum MessageType {
        CHAT, JOIN, LEAVE
    }
    
    private MessageType type;
    private String sender;
    private String content;
}
