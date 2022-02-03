package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.Payload.PayloadType;
import com.example.notemvcwebsocketserver.entity.User;
import com.example.notemvcwebsocketserver.entity.Payload;
import com.example.notemvcwebsocketserver.entity.StatusInfo;
import com.example.notemvcwebsocketserver.messaging.RedisPublisher;
import com.example.notemvcwebsocketserver.messaging.RedisSubscriber;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class NoteService {
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    private final RedisPublisher redisPublisher;
    private final RedisSubscriber redisSubscriber;
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisService redisService;
    ObjectMapper objectMapper = new ObjectMapper();
    
    public void enter(Payload payload, String sessionId){
        String noteId = payload.getNoteId();
        User user = User.builder()
            .id(payload.getMyUser().getId())
            .name(payload.getMyUser().getName())
            .build();
        
        redisService.insertConnection(noteId, sessionId, user);
        redisService.setSessionData(sessionId, noteId);
        
        // 첫 입장할 때 message listener 등록
        redisMessageListener.addMessageListener(redisSubscriber, new ChannelTopic(payload.getNoteId()));
        
        String owner = redisService.getData(noteId);
        List<String> userList = redisService.getConnectionList(noteId);
        StatusInfo statusInfo;
        if (owner == null || owner.equals("")){
            statusInfo = StatusInfo.builder().userList(userList).build();
        }
        else{
            statusInfo = StatusInfo.builder().owner(owner).userList(userList).build();
        }
        //현재 입장한 사용자에게만 전송
        simpMessagingTemplate.convertAndSend("/user/note/"+payload.getMyUser().getId(), statusInfo);
        //모든 subscriber에게 전송
        redisPublisher.publish(ChannelTopic.of(noteId), payload);
    }
    
    //유저의 웹소켓 연결이 끊겼을 때
    public void disconnected(String sessionId){
        try {
            String noteId = redisService.getData(sessionId);
            User user = objectMapper.readValue(redisService.getConnection(noteId, sessionId),
                User.class);
            Payload unlock = Payload.builder()
                .noteId(noteId)
                .type(PayloadType.valueOf("UNLOCK"))
                .myUser(user)
                .build();
            Payload leave = Payload.builder()
                .noteId(noteId)
                .type(PayloadType.valueOf("LEAVE"))
                .myUser(user)
                .build();
    
            // redis에서 선점자면 선점 정보 삭제, Unlock 알림
            String ownerStr = redisService.getData(noteId);
            if(ownerStr != null && !ownerStr.equals("") && objectMapper.readValue(ownerStr, User.class).getId().equals(user.getId())){
                redisService.setLockNull(noteId);
                redisPublisher.publish(ChannelTopic.of(noteId), unlock);
                log.info("disconnect (unlock) " + noteId+ "-" + user.getId().toString());
            }

            // redis에서 connection 삭제, leave 알림
            redisService.removeConnection(noteId, sessionId);
            redisService.deleteSessionData(sessionId);
            redisPublisher.publish(ChannelTopic.of(noteId), leave);
            log.info("disconnect (leave) " + noteId+ "-" + user.getId().toString());
        }
        catch(JsonProcessingException e){
            log.error("Json Proccessing Exception");
        }
    }
    
    public void update(Payload payload){
        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
    }
    
    public void lock(Payload payload){
        //선점자 표시 (현재 상태가 null인 경우에만 선점 가능)
        String noteId = payload.getNoteId();
        String ownerId = redisService.getData(noteId);
        if (ownerId == null || ownerId.equals("")){
            redisService.setUser(noteId, User.builder()
                .id(payload.getMyUser().getId())
                .name(payload.getMyUser().getName())
                .build());
            redisPublisher.publish(ChannelTopic.of(noteId), payload);
        }
    }
    public void unlock(Payload payload, String sessionId){
        //선점상태 해지 (현재 상태에 선점자가 있을 경우에만 선점 가능)
        String noteId = payload.getNoteId();
        String ownerIdStr = redisService.getData(noteId);
        if (ownerIdStr != null){
            try {
                User user = objectMapper.readValue(redisService.getConnection(noteId, sessionId), User.class);
                Long ownerId = user.getId();
                if(ownerId.equals(payload.getMyUser().getId())) {
                    redisService.setLockNull(noteId);
                    redisPublisher.publish(ChannelTopic.of(noteId), payload);
                    log.info("unlock " + noteId + "-" + user.getId().toString());
                }
            }
            catch(JsonProcessingException e){
                log.error("Json Proccessing Exception");
            }
        }
    }
}
