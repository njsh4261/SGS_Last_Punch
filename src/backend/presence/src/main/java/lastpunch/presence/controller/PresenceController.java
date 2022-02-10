package lastpunch.presence.controller;

import java.util.Map;
import lastpunch.presence.dto.PresenceDto;
import lastpunch.presence.service.RabbitMQService;
import lastpunch.presence.service.RedisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class PresenceController{
    private final RabbitMQService rabbitMQService;
    private final RedisService redisService;
    
    @Autowired
    public PresenceController(RabbitMQService rabbitMQService, RedisService redisService){
        this.rabbitMQService = rabbitMQService;
        this.redisService = redisService;
    }
    
    @MessageMapping("/update")
    public void updateUserStatus(PresenceDto presenceDto){
        rabbitMQService.updateUserStatus(presenceDto);
    }
    
    @GetMapping("/presence/{id}")
    public ResponseEntity<Object> getMemberPresence(@PathVariable("id") String workspaceId){
        return new ResponseEntity<>(
            Map.of(
                "code", "14000",
                "data", redisService.getMemberPresence(workspaceId)
            ),
            HttpStatus.OK
        );
    }
}
