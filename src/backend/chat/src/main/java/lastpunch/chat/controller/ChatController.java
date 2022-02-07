package lastpunch.chat.controller;

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
import org.springframework.web.bind.annotation.RequestBody;

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
    
    @MessageMapping("/chat")
    public void send(SendDto sendDto){
        logger.info("message received: " + sendDto);
        rabbitMqService.send(sendDto.toEntity());
    }
    
    @PostMapping("/chat/recent")
    public ResponseEntity<Object> getRecentMessages(@RequestBody EnterDto enterDto){
        logger.info("EnterDTO: " + enterDto.toString());
        return new ResponseEntity<>(
            Map.of(
                "code", "13000",
                "data", mongoDbService.getRecentMessages(enterDto.getChannelId())
            ),
            HttpStatus.OK
        );
    }
    
    @PostMapping("/chat/old")
    public ResponseEntity<Object> getOldMessages(@RequestBody GetOlderDto getOlderDto){
        return new ResponseEntity<>(
            Map.of(
                "code", "13000",
                "data", mongoDbService.getOldMessages(getOlderDto)
            ),
            HttpStatus.OK
        );
    }
}
