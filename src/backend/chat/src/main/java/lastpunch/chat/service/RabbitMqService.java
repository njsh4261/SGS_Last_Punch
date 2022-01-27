package lastpunch.chat.service;

import com.rabbitmq.client.UnblockedCallback;
import lastpunch.chat.common.ChatConstant;
import lastpunch.chat.entity.Message;
import lastpunch.chat.entity.Message.EnterDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMqService{
    private final RabbitTemplate rabbitTemplate;
    private final MongoDbService mongoDbService;
    private final Logger logger;
    
    @Autowired
    public RabbitMqService(RabbitTemplate rabbitTemplate, MongoDbService mongoDbService){
        this.rabbitTemplate = rabbitTemplate;
        this.mongoDbService = mongoDbService;
        logger = LoggerFactory.getLogger(RabbitMqService.class);
    }
    
    public void getRecentMessages(EnterDto enterDto){
        rabbitTemplate.convertAndSend(
            ChatConstant.AMQ_TOPIC,
            ChatConstant.ROUTING_KEY_PREFIX + enterDto.getChannelId(),
            mongoDbService.getRecentMessages(enterDto.getChannelId())
        );
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
