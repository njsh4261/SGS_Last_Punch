package lastpunch.chat.controller;

import java.time.LocalDateTime;
import lastpunch.chat.common.ChatConstant;
import lastpunch.chat.dto.Message;
import lastpunch.chat.service.RabbitService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;

public class ChatController{
    private final Logger logger;
    private final RabbitService rabbitService;
    
    @Autowired
    public ChatController(RabbitService rabbitService){
        this.logger = LoggerFactory.getLogger(ChatController.class);
        this.rabbitService = rabbitService;
    }
    
    @RabbitListener(queues = ChatConstant.QUEUE_NAME)
    public void receive(Message message){
        logger.info("received: " + message.toString());
    }
    
    @MessageMapping("/channel.{channelId}")
    public void send(Message message, @DestinationVariable String channelId){
        rabbitService.send(message, channelId);
    }
    
    // for test
    @MessageMapping("/channel.addUser")
    public Message addUser(@Payload Message message, SimpMessageHeaderAccessor headerAccessor) {
        headerAccessor.getSessionAttributes().put("username", message.getSender());
        return message;
    }
}
