package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.User;
import com.example.notemvcwebsocketserver.entity.Payload;
import com.example.notemvcwebsocketserver.entity.StatusInfo;
import com.example.notemvcwebsocketserver.messaging.RedisPublisher;
import com.example.notemvcwebsocketserver.messaging.RedisSubscriber;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class NoteService {
    private final RedisPublisher redisPublisher;
    private final RedisSubscriber redisSubscriber;
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisService redisService;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    
    public void enter(Payload payload){
//        headerAccessor.getSessionAttributes().put("username", payload.getUserId());
        redisService.insertList(payload.getNoteId(),
            User.builder()
                .id(payload.getMyUser().getId())
                .name(payload.getMyUser().getName())
                .build());
        // 첫 입장할 때 message listener 등록
        redisMessageListener.addMessageListener(redisSubscriber, new ChannelTopic(payload.getNoteId()));
        
        String owner = redisService.getData(payload.getNoteId());
        List<String> userList = redisService.getList(payload.getNoteId());
        StatusInfo statusInfo = StatusInfo.builder().owner(owner).userList(userList).build();
        //현재 입장한 사용자에게만 전송
        System.out.println("/user/note/"+payload.getMyUser().getId());
        System.out.println("statusInfo = " + statusInfo);
        simpMessagingTemplate.convertAndSend("/user/note/"+payload.getMyUser().getId(), statusInfo);
        //모든 subscriber에게 전송
        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
    }
    
    public void leave(Payload payload){
        redisService.removeList(payload.getNoteId(),
            User.builder()
                .id(payload.getMyUser().getId())
                .name(payload.getMyUser().getName())
                .build());
        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
    }
    
    public void update(Payload payload){
        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
    }
    
    public void lock(Payload payload){
        //선점자 표시 (현재 상태가 null인 경우에만 선점 가능)
        String ownerId = redisService.getData(payload.getNoteId());
        if (ownerId == null || ownerId == ""){
            System.out.println("payload = " + payload);
            redisService.setData(payload.getNoteId(), User.builder()
                .id(payload.getMyUser().getId())
                .name(payload.getMyUser().getName())
                .build());
            redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
        }
    }
    public void unlock(Payload payload){
        //선점상태 해지 (현재 상태에 선점자가 있을 경우에만 선점 가능)
        String ownerId = redisService.getData(payload.getNoteId());
        if (ownerId != null && ownerId != ""){
            redisService.setNullData(payload.getNoteId());
            redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
        }
    }
}
