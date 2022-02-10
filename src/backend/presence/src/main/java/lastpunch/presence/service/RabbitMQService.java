package lastpunch.presence.service;

import lastpunch.presence.common.PresenceConstant;
import lastpunch.presence.dto.PresenceDto;
import lastpunch.presence.repository.PresenceRepository;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMQService{
    private final RabbitTemplate rabbitTemplate;
    private final PresenceRepository presenceRepository;
    
    @Autowired
    public RabbitMQService(RabbitTemplate rabbitTemplate, PresenceRepository presenceRepository){
        this.rabbitTemplate = rabbitTemplate;
        this.presenceRepository = presenceRepository;
    }
    
    public void updateUserStatus(PresenceDto presenceDto){
        presenceRepository.save(presenceDto);
        rabbitTemplate.convertAndSend(
            PresenceConstant.AMQ_TOPIC,
            PresenceConstant.ROUTING_KEY_PREFIX + presenceDto.getWorkspaceId(),
            presenceDto
        );
    }
}
