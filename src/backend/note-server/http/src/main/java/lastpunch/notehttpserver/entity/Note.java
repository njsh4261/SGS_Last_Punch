package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.dto.NoteInfo;
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
    private Long workspace_id;
    
    @NotNull
    private Long channel_id;
    
    private List<Block> blocks;
    
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
    
    public NoteInfo toNoteInfo(){
        String title = blocks.get(0).getContent();
        return NoteInfo.builder()
            .id(id.toString())
            .title(title)
            .createdt(createdt)
            .modifydt(modifydt)
            .build();
    }
}