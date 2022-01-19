package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.List;
import lastpunch.notehttpserver.entity.Block;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GetNoteResponse{
    private String id;
    private List<Block> blocks;
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
}