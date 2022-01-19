package lastpunch.notehttpserver.dto;

import java.util.List;
import lombok.Data;

@Data
public class SyncNoteRequest {
    private String noteId;
    private List<String> queryBlockId;
}
