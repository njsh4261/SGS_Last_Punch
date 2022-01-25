package lastpunch.chat.service;

import java.time.LocalDateTime;
import lastpunch.chat.common.ChatConstant;
import lastpunch.chat.dto.Message;
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
    
    public void send(Message message, String channelId){
        message.setCreateDt(LocalDateTime.now());
        rabbitTemplate.convertAndSend(
//            ChatConstant.AMQ_TOPIC,
            ChatConstant.ROUTING_KEY_PREFIX + channelId,
            message
        );
    }
}
