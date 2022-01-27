package lastpunch.chat.entity;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Message{
    @Id
    private String id;
    
    private String authorId;
    private String channelId;
    private String content;
    private Integer status;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
    
    @Getter
    public static class EnterDto{
        private String channelId;
    }
    
    @Getter
    public static class SendDto{
        private String authorId;
        private String channelId;
        private String content;
        
        public Message toEntity(){
            return Message.builder()
                .authorId(authorId)
                .channelId(channelId)
                .content(content)
                .status(0)
                .createDt(LocalDateTime.now())
                .modifyDt(LocalDateTime.now())
                .build();
        }
    }
}
