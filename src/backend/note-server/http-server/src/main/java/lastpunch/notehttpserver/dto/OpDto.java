package lastpunch.notehttpserver.dto;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.entity.Op;
import lombok.Data;

public class OpDto {
    @Data
    public static class saveRequest {
        @NotNull
        private String noteId;
        @NotNull
        private String op;
        @NotNull
        private String timestamp;
      
        public Op toEntity(){
            return Op.builder()
                .op(op)
                .timestamp(Date.from(Instant.parse(timestamp)))
                .build();
        }
    }
}
