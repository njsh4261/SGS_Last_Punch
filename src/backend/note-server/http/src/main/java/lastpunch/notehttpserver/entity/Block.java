package lastpunch.notehttpserver.entity;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Builder
@Document("blocks")
public class Block {
    @Id
    private String id;
    private String type;
    private String parentBlockId;
    private LocalDateTime lastModifyDt;
    private Long lastWriter;
    // Todo: frontend에 따라 content 타입 수정
    private String content;
}
