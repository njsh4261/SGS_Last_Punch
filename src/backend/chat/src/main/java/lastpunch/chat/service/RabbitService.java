package lastpunch.chat.service;

import java.time.LocalDateTime;
import lastpunch.chat.common.ChatConstant;
import lastpunch.chat.entity.Message;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitService{
    private final RabbitTemplate rabbitTemplate;
    
    @Autowired
    public RabbitService(RabbitTemplate rabbitTemplate){
        this.rabbitTemplate = rabbitTemplate;
    }
    
    public void send(Message message){
        rabbitTemplate.convertAndSend(
            ChatConstant.AMQ_TOPIC,
            ChatConstant.ROUTING_KEY_PREFIX + message.getChannelId(),
            message
        );
    }
}
