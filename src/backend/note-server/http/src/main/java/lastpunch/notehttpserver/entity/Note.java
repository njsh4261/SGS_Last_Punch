package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import java.util.List;
import javax.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("notes")
@Getter
@Setter
@Builder
public class Note {
    @Id
    private ObjectId id;
    
    @NotNull
    private Long workspace_id;
    
    @NotNull
    private Long channel_id;
    
    @NotNull
    private String title;
    
    private List<Clock> content;
    
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
}