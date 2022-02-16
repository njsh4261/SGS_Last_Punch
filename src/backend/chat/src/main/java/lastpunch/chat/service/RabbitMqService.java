package lastpunch.chat.service;

import lastpunch.chat.common.ChatConstant;
import lastpunch.chat.entity.ChatMessage;
import lastpunch.chat.entity.ChatMessage.TypingDto;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMqService{
    private final RabbitTemplate rabbitTemplate;
    private final MongoService mongoService;
    
    @Autowired
    public RabbitMqService(RabbitTemplate rabbitTemplate, MongoService mongoService){
        this.rabbitTemplate = rabbitTemplate;
        this.mongoService = mongoService;
    }
    
    // 사용자에 의해 MESSAGE 타입의 메시지가 온 경우
    public void sendChatMessage(ChatMessage chatMessage){
        mongoService.saveMessage(chatMessage);
        rabbitTemplate.convertAndSend(
            ChatConstant.AMQ_TOPIC,
            ChatConstant.ROUTING_KEY_PREFIX + chatMessage.getChannelId(),
            chatMessage
        );
    }
    
    // 사용자에 의해 TYPING_START 혹은 TYPING_END 타입의 메시지가 온 경우
    public void sendTypingStatus(TypingDto typingDto){
        rabbitTemplate.convertAndSend(
            ChatConstant.AMQ_TOPIC,
            ChatConstant.ROUTING_KEY_PREFIX + typingDto.getChannelId(),
            typingDto
        );
    }
}
