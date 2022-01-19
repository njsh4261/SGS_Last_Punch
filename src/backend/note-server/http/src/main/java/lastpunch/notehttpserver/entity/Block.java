package lastpunch.notehttpserver.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("blocks")
@Getter
@Setter
@ToString
public class Block {
    @Id
    private ObjectId id;
    private ObjectId note_id;
    private String text;
    private Long ver;
}
