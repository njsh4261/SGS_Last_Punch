package com.example.notemvcwebsocketserver.repository;

import com.example.notemvcwebsocketserver.messaging.RedisSubscriber;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Repository;

@RequiredArgsConstructor
@Repository
public class NoteRoomRepository {
    private final RedisMessageListenerContainer redisMessageListener;
    private final RedisSubscriber redisSubscriber;
    private static final String NOTE = "NOTE";
    private final RedisTemplate<String, Object> redisTemplate;
//    private HashOperations<String, String, ChatRoom> opsHashChatRoom;
    // 채팅방의 대화 메시지를 발행하기 위한 redis topic 정보. 서버별로 채팅방에 매치되는 topic정보를 Map에 넣어 roomId로 찾을수 있도록 한다.
    private Map<String, ChannelTopic> topics;
    
//    @PostConstruct
//    private void init() {
//        opsHashChatRoom = redisTemplate.opsForHash();
//        topics = new HashMap<>();
//    }
//
//    public List<ChatRoom> findAllRoom() {
//        return opsHashChatRoom.values(CHAT_ROOMS);
//    }
//
//    public ChatRoom findRoomById(String id) {
//        return opsHashChatRoom.get(NOTE, id);
//    }
//
//    /**
//     * 채팅방 생성 : 서버간 채팅방 공유를 위해 redis hash에 저장한다.
//     */
//    public ChatRoom createChatRoom(String name) {
//        ChatRoom chatRoom = ChatRoom.create(name);
//        opsHashChatRoom.put(CHAT_ROOMS, chatRoom.getRoomId(), chatRoom);
//        return chatRoom;
//    }
//
    // redis에 noteId로 topic을 만들고, 리스너 설정
    // 이미 해당 noteId로 생성된 topic이 있을 경우 불러오고, 아니라면 새 ChannelTopic 생성
    public void enterNote(String noteId) {
//        ChannelTopic topic = topics.get(noteId);
//        if (topic == null) {
//            topic = new ChannelTopic(noteId);
            redisMessageListener.addMessageListener(redisSubscriber, new ChannelTopic(noteId));
//            topics.put(noteId, topic);
//        }
    }
    
    // redis에서 noteId로 topic 가져오기
    public ChannelTopic getTopic(String noteId) {
        return topics.get(noteId);
    }
}