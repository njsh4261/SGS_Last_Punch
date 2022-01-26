package lastpunch.chat.entity;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;

@Getter
@Builder
@ToString
public class Message{
    @Id
    private String id;
    
    private String authorId;
    private String workspaceId;
    private String channelId;
    private String content;
    private Integer status;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
    
    @Getter
    public class Dto{
        private String authorId;
        private String workspaceId;
        private String channelId;
        private String content;
        
        public Message toEntity(){
            return Message.builder()
                .authorId(authorId)
                .workspaceId(workspaceId)
                .channelId(channelId)
                .content(content)
                .status(0)
                .createDt(LocalDateTime.now())
                .modifyDt(LocalDateTime.now())
                .build();
        }
    }
}
