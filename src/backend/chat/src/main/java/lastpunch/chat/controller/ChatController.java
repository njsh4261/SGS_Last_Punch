package lastpunch.chat.controller;

import java.time.LocalDateTime;
import java.util.Map;
import lastpunch.chat.entity.Message.EnterDto;
import lastpunch.chat.entity.Message.GetOlderDto;
import lastpunch.chat.entity.Message.SendDto;
import lastpunch.chat.service.MongoDbService;
import lastpunch.chat.service.RabbitMqService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

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
    
    @MessageMapping("/chat")
    public void send(SendDto sendDto){
        rabbitMqService.send(sendDto.toEntity());
    }
    
    @PostMapping("/chat/older")
    public ResponseEntity<Object> getOlderMessages(GetOlderDto getOlderDto){
        return new ResponseEntity<>(
            Map.of(
                "code", "13000",
                "data", mongoDbService.getOlderMessages(getOlderDto)
            ),
            HttpStatus.OK
        );
    }
}
