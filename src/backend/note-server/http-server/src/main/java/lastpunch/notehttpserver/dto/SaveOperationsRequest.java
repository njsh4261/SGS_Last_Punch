package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Op;
import lombok.Data;

@Data
public class SaveOperationsRequest {
    @NotNull
    private String noteId;
    private String op;
    private String timestamp;
}
