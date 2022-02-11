package lastpunch.presence.controller;

import java.util.Map;
import lastpunch.presence.common.PresenceConstant;
import lastpunch.presence.dto.UpdateDto;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.service.RabbitMQService;
import lastpunch.presence.service.MongoService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class PresenceController{
    private final RabbitMQService rabbitMQService;
    private final MongoService mongoService;
    private final Logger logger;
    
    @Autowired
    public PresenceController(RabbitMQService rabbitMQService, MongoService mongoService){
        this.rabbitMQService = rabbitMQService;
        this.mongoService = mongoService;
        this.logger = LoggerFactory.getLogger(PresenceController.class);
    }
    
    @MessageMapping("/update")
    public void updateUserStatus(Message<Presence.UpdateDto> message){
        logger.info("received: " + message.getPayload());
        rabbitMQService.updateUserStatus(
            message.getPayload(),
            (String) message.getHeaders().get(PresenceConstant.SIMP_SESSION_ID)
        );
    }
    
    @GetMapping("/presence/{id}")
    public ResponseEntity<Object> getMemberPresence(@PathVariable("id") String workspaceId){
        return new ResponseEntity<>(
            Map.of(
                "code", "14000",
                "data", mongoService.getByWorkspaceId(workspaceId)
            ),
            HttpStatus.OK
        );
    }
}
