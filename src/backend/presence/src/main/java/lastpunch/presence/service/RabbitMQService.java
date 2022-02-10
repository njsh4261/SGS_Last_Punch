package lastpunch.presence.service;

import java.util.Optional;
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
    
    public void updateUserStatus(UpdateDto updateDto, String sessionId){
        mongoService.save(updateDto.toEntity(sessionId));
        sendMessage(updateDto);
    }
    
    public void deleteUserStatus(String sessionId){
        if(sessionId != null){
            Optional<Presence> optionalPresence = mongoService.getOne(sessionId);
            if(optionalPresence.isPresent()){
                Presence presence = optionalPresence.get();
                mongoService.delete(presence);
                presence.setUserStatus(UserStatus.DISCONNECT);
                sendMessage(presence.toDto());
            }
        }
    }
    
    public void sendMessage(UpdateDto updateDto){
        rabbitTemplate.convertAndSend(
            PresenceConstant.AMQ_TOPIC,
            PresenceConstant.ROUTING_KEY_PREFIX + updateDto.getWorkspaceId(),
            updateDto
        );
    }
}
