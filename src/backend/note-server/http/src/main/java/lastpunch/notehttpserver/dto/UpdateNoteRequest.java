package lastpunch.notehttpserver.dto;

import java.util.List;
import lombok.Data;

@Data
public class UpdateNoteRequest {
    private String noteId;
    private List<Transaction> transactions;
}
