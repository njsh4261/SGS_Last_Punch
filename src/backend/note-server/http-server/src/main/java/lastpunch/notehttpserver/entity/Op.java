package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Builder
public class Op {
    private String op;
    private LocalDateTime timestamp;
}
