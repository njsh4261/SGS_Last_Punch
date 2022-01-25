package lastpunch.chat.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class Message{
    private MessageType type;
    private String content;
    private String sender;
    
    private String channel;
    private LocalDateTime createDt;
    
    public enum MessageType {
        CHAT,
        JOIN,
        LEAVE
    }
}
