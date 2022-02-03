package com.example.notemvcwebsocketserver.messaging;

import com.example.notemvcwebsocketserver.entity.Payload;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class RedisPublisher {
    private final RedisTemplate<String, Object> redisTemplate;
    
    public void publish(ChannelTopic topic, Payload payload) {
        redisTemplate.convertAndSend(topic.getTopic(), payload);
    }
}

