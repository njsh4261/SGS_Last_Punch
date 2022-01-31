package lastpunch.notehttpserver.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Data;

@Data
public class UpdateNoteRequest {
    private String noteId;
    private String title;
    private String content;
    private LocalDateTime modifyDt;
}
