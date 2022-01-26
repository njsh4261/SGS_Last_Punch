package com.example.notemvcwebsocketserver.entity;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class Payload {
    // 메시지 타입 : 입장, 노트 업데이트
    public enum MessageType {
        ENTER, UPDATE, CURSOR
    }
    private MessageType type; // 메시지 타입
    private String noteId; // 노트 번호
    private String sender; // 메세지 보낸 사람 id
    private List<String> blockId; // 업데이트된 블록들 id
    private LocalDateTime createDt;
}