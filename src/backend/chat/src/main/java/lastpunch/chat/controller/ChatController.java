package lastpunch.chat.controller;

import java.util.Map;
import lastpunch.chat.entity.ChatMessage.EnterDto;
import lastpunch.chat.entity.ChatMessage.GetOlderDto;
import lastpunch.chat.entity.ChatMessage.ReceiveDto;
import lastpunch.chat.service.MongoService;
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
    private final MongoService mongoService;
    private final Logger logger;

    @Autowired
    public ChatController(RabbitMqService rabbitMqService, MongoService mongoService){
        this.mongoService = mongoService;
        this.rabbitMqService = rabbitMqService;
        logger = LoggerFactory.getLogger(ChatController.class);
    }
    
    @MessageMapping("/chat")
    public void send(ReceiveDto receiveDto){
        logger.info("message received: " + receiveDto);
        switch(receiveDto.getType()){
            case TYPING:
                rabbitMqService.sendTypingStatus(receiveDto.toTypingDto());
                break;
            case MESSAGE:
                rabbitMqService.sendChatMessage(receiveDto.toEntity());
                break;
        }
    }
    
    @PostMapping("/chat/recent")
    public ResponseEntity<Object> getRecentMessages(@RequestBody EnterDto enterDto){
        return new ResponseEntity<>(
            Map.of(
                "code", "13000",
                "data", mongoService.getRecentMessages(enterDto.getChannelId())
            ),
            HttpStatus.OK
        );
    }
    
    @PostMapping("/chat/old")
    public ResponseEntity<Object> getOldMessages(@RequestBody GetOlderDto getOlderDto){
        return new ResponseEntity<>(
            Map.of(
                "code", "13000",
                "data", mongoService.getOldMessages(getOlderDto)
            ),
            HttpStatus.OK
        );
    }
}
