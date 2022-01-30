package com.example.notemvcwebsocketserver.entity;

import com.fasterxml.jackson.databind.util.JSONPObject;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import netscape.javascript.JSObject;

@Data
public class Payload {
    public enum PayloadType {
        ENTER, LEAVE, UPDATE, LOCK, UNLOCK, CURSOR;
    }
    private PayloadType type;
    private String noteId;
    private User myUser;
    private LocalDateTime timestamp;
}