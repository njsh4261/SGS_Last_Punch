package lastpunch.presence.service;

import lastpunch.presence.common.PresenceConstant;
import lastpunch.presence.common.UserStatus;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.entity.Presence.UpdateDto;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMQService{
    private final RabbitTemplate rabbitTemplate;
    private final MongoService mongoService;
    
    @Autowired
    public RabbitMQService(RabbitTemplate rabbitTemplate, MongoService mongoService){
        this.rabbitTemplate = rabbitTemplate;
        this.mongoService = mongoService;
    }
    
    public void updateUserStatus(Presence.UpdateDto updateDto, String sessionId){
        // 메시지를 MongoDB에 저장 및 subscriber에게 메시지 전달
        mongoService.saveOrUpdate(updateDto, sessionId);
        if(UserStatus.toEnum(updateDto.getUserStatus()) == UserStatus.CONNECT){
            updateDto.setUserStatus(UserStatus.ONLINE.toString());
        }
        sendMessage(updateDto);
    }

    public void deleteUserStatus(String sessionId){
        // 어떤 세션의 유저가 연결을 종료할 때, DB에 상태 변화 업데이트
        // 이후 해당 유저가 속해있던 워크스페이스 멤버들에게 상태 변화 전파
        mongoService.deleteOrUpdate(sessionId).ifPresent(this::sendMessage);
    }
    
    public void sendMessage(Presence.UpdateDto updateDto){
        // 해당 워크스페이스의 멤버에게 상태 변화가 있을 때, 해당 워크스페이스의 exchange에 상태 변화 전파
        rabbitTemplate.convertAndSend(
            PresenceConstant.AMQ_TOPIC,
            PresenceConstant.ROUTING_KEY_PREFIX + updateDto.getWorkspaceId(),
            updateDto
        );
    }
}
