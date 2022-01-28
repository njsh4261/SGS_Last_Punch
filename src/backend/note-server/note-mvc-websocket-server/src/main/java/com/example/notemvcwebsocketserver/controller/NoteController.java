package com.example.notemvcwebsocketserver.controller;

import com.example.notemvcwebsocketserver.entity.Payload;
import com.example.notemvcwebsocketserver.messaging.RedisPublisher;
import com.example.notemvcwebsocketserver.messaging.RedisSubscriber;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@RequiredArgsConstructor
@Controller
public class NoteController {
    private final RedisPublisher redisPublisher;
    private final RedisSubscriber redisSubscriber;
    private final RedisMessageListenerContainer redisMessageListener;
    
    @MessageMapping("/note")
    public void message(Payload payload) {
        System.out.println("payload = " + payload.getType());
        if(Payload.MessageType.ENTER.equals(payload.getType())){
            System.out.println("here");
            redisMessageListener.addMessageListener(redisSubscriber, new ChannelTopic(payload.getNoteId()));
        }
        System.out.println("payload.getNoteId() = " + payload.getNoteId());
        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
    }
}