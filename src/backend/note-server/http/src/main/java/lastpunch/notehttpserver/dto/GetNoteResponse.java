package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Block;
import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;

@Data
@Builder
public class GetNoteResponse{
    private String id;
    private String title;
    private List<Block> content;
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
}