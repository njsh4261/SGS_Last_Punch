package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import java.util.Date;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Op {
    private String op;
    private Date timestamp;
}
