package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Block;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;

@Builder
@Getter
@Setter
public class NoteInfo {
    private String id;
    private String title;
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
}
