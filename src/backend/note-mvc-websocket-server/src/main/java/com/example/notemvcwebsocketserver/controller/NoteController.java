package com.example.notemvcwebsocketserver.controller;

import com.example.notemvcwebsocketserver.entity.Payload;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@RequiredArgsConstructor
@Controller
public class NoteController {
    
    private final SimpMessagingTemplate template;
    
    @MessageMapping("/note/update")
    public void message(Payload payload) {
        System.out.println("payload = " + payload);
//        if (Payload.MessageType.ENTER.equals(payload.getType()))
//            payload.setMessage(payload.getSender() + "님이 입장하셨습니다.");
        System.out.println("sub/note/" + payload.getNoteId());
        template.convertAndSend("sub/note/" + payload.getNoteId(), payload);
    }
}