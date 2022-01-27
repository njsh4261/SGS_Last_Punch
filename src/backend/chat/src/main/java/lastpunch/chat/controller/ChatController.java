package lastpunch.chat.controller;

import lastpunch.chat.entity.Message.EnterDto;
import lastpunch.chat.entity.Message.SendDto;
import lastpunch.chat.service.MongoDbService;
import lastpunch.chat.service.RabbitMqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController{
    private final RabbitMqService rabbitMqService;
    private final MongoDbService mongoDbService;

    @Autowired
    public ChatController(RabbitMqService rabbitMqService, MongoDbService mongoDbService){
        this.mongoDbService = mongoDbService;
        this.rabbitMqService = rabbitMqService;
    }
    
    @MessageMapping("/enter")
    public void getRecentMessages(EnterDto enterDto){
        rabbitMqService.getRecentMessages(enterDto);
    }
    
    @MessageMapping("/chat")
    public void send(SendDto sendDto){
        rabbitMqService.send(sendDto.toEntity());
    }
}
