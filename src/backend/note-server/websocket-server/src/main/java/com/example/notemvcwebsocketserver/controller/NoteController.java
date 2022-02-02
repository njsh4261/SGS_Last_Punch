package com.example.notemvcwebsocketserver.controller;

import com.example.notemvcwebsocketserver.entity.Payload;
import com.example.notemvcwebsocketserver.entity.Payload.PayloadType;
import com.example.notemvcwebsocketserver.messaging.RedisPublisher;
import com.example.notemvcwebsocketserver.messaging.RedisSubscriber;
import com.example.notemvcwebsocketserver.service.NoteService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Slf4j
@RequiredArgsConstructor
@Controller
public class NoteController {
    private final NoteService noteService;
    
    @MessageMapping("/note")
    public void pubNote(Payload payload, @Header("simpSessionId") String sessionId) {
        log.info(payload.getType().toString() + " " + payload);
        PayloadType type = payload.getType();
        if (PayloadType.ENTER.equals(type)){
            noteService.enter(payload, sessionId);
        }
        else if (PayloadType.UPDATE.equals(type) || PayloadType.UPDATE_TITLE.equals(type)){
            noteService.update(payload);
        }
        else if (PayloadType.LOCK.equals(type)){
            noteService.lock(payload);
        }
        else if (PayloadType.UNLOCK.equals(type)){
            noteService.unlock(payload, sessionId);
        }
    }
    
    @EventListener
    public void onDisconnectEvent(SessionDisconnectEvent event) {
        String sessionId = event.getMessage().getHeaders().get("simpSessionId").toString();
        noteService.disconnected(sessionId);
        log.info(sessionId + " disconnected");
    }
}
