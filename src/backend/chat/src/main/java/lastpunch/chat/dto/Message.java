package lastpunch.chat.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class Message{
    private String content;
    private String sender;
    private String channelId;
    private LocalDateTime createDt;
}
