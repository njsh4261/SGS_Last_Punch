package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.Payload.PayloadType;
import com.example.notemvcwebsocketserver.entity.User;
import com.example.notemvcwebsocketserver.entity.Payload;
import com.example.notemvcwebsocketserver.entity.StatusInfo;
import com.example.notemvcwebsocketserver.messaging.RedisPublisher;
import com.example.notemvcwebsocketserver.messaging.RedisSubscriber;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
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
    ObjectMapper objectMapper = new ObjectMapper();
    
    public void enter(Payload payload, String sessionId){
        String noteId = payload.getNoteId();
        User user = User.builder()
            .id(payload.getMyUser().getId())
            .name(payload.getMyUser().getName())
            .build();
        
        redisService.insertHash(payload.getNoteId(), sessionId, user);
        redisService.setSessionData(sessionId, noteId);
        
        // 첫 입장할 때 message listener 등록
        redisMessageListener.addMessageListener(redisSubscriber, new ChannelTopic(payload.getNoteId()));
        
        String owner = redisService.getData(noteId);
        List<String> userList = redisService.getHashList(noteId);
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
    
    //유저가 다른 화면으로 전환하거나 브라우저를 종료하여 웹소켓 연결이 끊겼을 때
//    public void leave(Payload payload, String sessionId){
//        redisService.removeHash(payload.getNoteId(), sessionId);
//        redisService.setSessionData(sessionId, "leave");
//        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
//    }
    
    //유저가 의도치않게 웹소켓 연결이 끊겼을 때 (network disconnected)
    public void leaveDisconnected(String sessionId){
        if (!redisService.getData(sessionId).equals("leave")) {
            try {
                String noteId = redisService.getData(sessionId);
                User user = objectMapper.readValue(redisService.getHashData(noteId, sessionId),
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
                System.out.println("ownerStr = " + ownerStr);
                System.out.println("user = " + user);
                if(ownerStr != null && !ownerStr.equals("") && objectMapper.readValue(ownerStr, User.class).getId().equals(user.getId())){
                    redisService.setNullData(noteId);
                    redisPublisher.publish(ChannelTopic.of(noteId), unlock);
                }

                // redis에서 connection 삭제, leave 알림
                redisService.removeHash(noteId, sessionId);
                redisService.removeSessionData(sessionId);
                redisPublisher.publish(ChannelTopic.of(noteId), leave);
            }
            catch(Exception e){
                System.out.println("exception leave disconnected = " + e);
            }
        }
    }
    
    public void update(Payload payload){
        redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
    }
    
    public void lock(Payload payload){
        //선점자 표시 (현재 상태가 null인 경우에만 선점 가능)
        String ownerId = redisService.getData(payload.getNoteId());
        if (ownerId == null || ownerId.equals("")){
            redisService.setData(payload.getNoteId(), User.builder()
                .id(payload.getMyUser().getId())
                .name(payload.getMyUser().getName())
                .build());
            redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
        }
    }
    public void unlock(Payload payload, String sessionId){
        //선점상태 해지 (현재 상태에 선점자가 있을 경우에만 선점 가능)
        String ownerIdStr = redisService.getData(payload.getNoteId());
        if (ownerIdStr == null){
            System.out.println("ownerId is null");
        }
        else {
            try {
                User user = objectMapper.readValue(redisService.getHashData(payload.getNoteId(), sessionId), User.class);
                Long ownerId = user.getId();
                if(ownerId.equals(payload.getMyUser().getId())) {
                    redisService.setNullData(payload.getNoteId());
                    redisPublisher.publish(ChannelTopic.of(payload.getNoteId()), payload);
                }
            }
            catch(Exception e){
                System.out.println("redis exception = " + e);
            }
        }
    }
}
