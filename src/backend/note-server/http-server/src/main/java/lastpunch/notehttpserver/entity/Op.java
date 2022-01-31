package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class Op {
    private String op;
    private LocalDateTime timestamp;
}
