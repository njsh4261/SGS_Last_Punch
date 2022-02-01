package lastpunch.notehttpserver.dto;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class TitleDto {
    private String noteId;
    private String title;
}
