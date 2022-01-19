package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Block;
import lastpunch.notehttpserver.entity.Note;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;

@AllArgsConstructor
@RequiredArgsConstructor
@Setter
@Getter
public class CreateNoteRequest {
    @NotNull
    private Long workspace_id;
    @NotNull
    private Long channel_id;
    @NotNull
    private String title;
    
    public Note toEntity(){
        return Note.builder()
            .workspace_id(workspace_id)
            .channel_id(channel_id)
            .title(title)
            .content(new ArrayList<>())
            .createdt(LocalDateTime.now())
            .modifydt(LocalDateTime.now())
            .build();
    }
}