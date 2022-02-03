package lastpunch.chat.service;

import lastpunch.chat.common.ChatConstant;
import lastpunch.chat.entity.Message;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMqService{
    private final RabbitTemplate rabbitTemplate;
    private final MongoDbService mongoDbService;
    
    @Autowired
    public RabbitMqService(RabbitTemplate rabbitTemplate, MongoDbService mongoDbService){
        this.rabbitTemplate = rabbitTemplate;
        this.mongoDbService = mongoDbService;
    }
    
    public void send(Message message){
        mongoDbService.saveMessage(message);
        rabbitTemplate.convertAndSend(
            ChatConstant.AMQ_TOPIC,
            ChatConstant.ROUTING_KEY_PREFIX + message.getChannelId(),
            message
        );
    }
}
