package lastpunch.notehttpserver.dto;

import java.util.List;
import lombok.Data;

@Data
public class UpdateNoteRequest {
    private String note_id;
    private List<BlockDto> transactions;
}
