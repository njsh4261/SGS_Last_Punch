package lastpunch.chat.controller;

import java.time.LocalDateTime;
import lastpunch.chat.entity.Message;
import lastpunch.chat.service.RabbitService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController{
    private final Logger logger;
    private final RabbitService rabbitService;

    @Autowired
    public ChatController(RabbitService rabbitService){
        this.logger = LoggerFactory.getLogger(ChatController.class);
        this.rabbitService = rabbitService;
    }
    
    @MessageMapping("/chat")
    public void send(Message.Dto messageDto){
        rabbitService.send(messageDto.toEntity());
    }
}
