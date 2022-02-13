package lastpunch.presence.service;

import lastpunch.presence.common.PresenceConstant;
import lastpunch.presence.entity.Presence;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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
        mongoService.saveOrUpdate(updateDto, sessionId);
        sendMessage(updateDto);
    }

    public void deleteUserStatus(String sessionId){
        List<Presence.UpdateDto> deleteList = mongoService.deleteOrUpdate(sessionId);
        if(!deleteList.isEmpty()){
            for(Presence.UpdateDto updateDto: deleteList){
                sendMessage(updateDto);
            }
        }
    }
    
    public void sendMessage(Presence.UpdateDto updateDto){
        rabbitTemplate.convertAndSend(
            PresenceConstant.AMQ_TOPIC,
            PresenceConstant.ROUTING_KEY_PREFIX + updateDto.getWorkspaceId(),
            updateDto
        );
    }
}
