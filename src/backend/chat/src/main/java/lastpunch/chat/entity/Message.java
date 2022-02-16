package lastpunch.chat.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "messages")
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
    
    @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
    private LocalDateTime createDt;
    
    @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
    private LocalDateTime modifyDt;
    
    @Getter
    @ToString
    public static class EnterDto{
        private String channelId;
    }
    
    @Getter
    public static class GetOlderDto{
        private String channelId;

        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime dateTime;
    }
    
    @Getter
    @ToString
    public static class SendDto{
        private String authorId;
        private String channelId;
        private String type;
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
