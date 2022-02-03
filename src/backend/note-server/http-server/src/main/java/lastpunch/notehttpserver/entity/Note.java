package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import java.util.List;
import javax.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("notes")
@Getter
@Setter
@Builder
@ToString
public class Note {
    @Id
    private ObjectId id;
    
    @NotNull
    private Long workspaceId;
    
    @NotNull
    private Long channelId;
    
    @NotNull
    private Long creatorId;
    
    private String title;
    private String content; // JSON string
    private List<Op> ops;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
}