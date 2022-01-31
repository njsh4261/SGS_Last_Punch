package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.List;
import lastpunch.notehttpserver.entity.Op;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GetNoteResponse{
    private String id;
    private Long creatorId;
    private String title;
    private String content;
    private List<Op> ops;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
}