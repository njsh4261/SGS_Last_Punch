package lastpunch.chat.controller;

import java.time.LocalDateTime;
import lastpunch.chat.entity.Message.EnterDto;
import lastpunch.chat.entity.Message.GetOlderDto;
import lastpunch.chat.entity.Message.SendDto;
import lastpunch.chat.service.MongoDbService;
import lastpunch.chat.service.RabbitMqService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController{
    private final RabbitMqService rabbitMqService;
    private final MongoDbService mongoDbService;
    private Logger logger;

    @Autowired
    public ChatController(RabbitMqService rabbitMqService, MongoDbService mongoDbService){
        this.mongoDbService = mongoDbService;
        this.rabbitMqService = rabbitMqService;
        logger = LoggerFactory.getLogger(ChatController.class);
    }
    
    @MessageMapping("/enter")
    public void getRecentMessages(EnterDto enterDto){
        rabbitMqService.getRecentMessages(enterDto);
    }
    
    @MessageMapping("/older")
    public void getRecentMessages(GetOlderDto getOlderDto){
//        logger.info("date time: " + getOlderDto.getDateTime().isBefore(LocalDateTime.now()));
        rabbitMqService.getOlderMessages(getOlderDto);
    }
    
    @MessageMapping("/chat")
    public void send(SendDto sendDto){
        rabbitMqService.send(sendDto.toEntity());
    }
}
