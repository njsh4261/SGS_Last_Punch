package lastpunch.notehttpserver.entity;

import lombok.Builder;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Builder
@Document("blocks")
public class Clock {
    @Id
    private ObjectId block_id;
    private String text;
    private Long ver;
}
