package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Note;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Data
public class CreateNoteRequest {
    @NotNull
    private Long workspaceId;
    @NotNull
    private Long channelId;
    @NotNull
    private String title;
    @NotNull
    private String titleBlockId;
    
    public Note toEntity(){
        return Note.builder()
            .workspace_id(workspaceId)
            .channel_id(channelId)
            .createdt(LocalDateTime.now())
            .modifydt(LocalDateTime.now())
            .build();
    }
}