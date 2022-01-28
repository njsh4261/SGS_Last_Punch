package com.example.notemvcwebsocketserver.messaging;

import com.example.notemvcwebsocketserver.entity.Payload;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class RedisSubscriber implements MessageListener {
    
    private final ObjectMapper objectMapper;
    private final RedisTemplate redisTemplate;
    private final SimpMessageSendingOperations messagingTemplate;
    
    // redis에서 publish하는 메세지 받아서 처리
    @Override
    public void onMessage(Message message, byte[] pattern) {
        try {
            String publishMessage = (String) redisTemplate.getStringSerializer().deserialize(message.getBody());
            Payload payload = objectMapper.readValue(publishMessage, Payload.class);
            System.out.println("payload = " + payload);
            System.out.println("/sub/note/" + payload.getNoteId());
            messagingTemplate.convertAndSend("/sub/note/" + payload.getNoteId(), payload);
        } catch (Exception e) {
            System.out.println("e = " + e);
        }
    }
}