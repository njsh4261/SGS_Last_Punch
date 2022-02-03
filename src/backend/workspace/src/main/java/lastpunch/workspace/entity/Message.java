package lastpunch.workspace.entity;

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
}
