package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import lastpunch.notehttpserver.entity.Clock;
import lastpunch.notehttpserver.entity.Note;
import lombok.Data;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;

@Data
public class BlockDto {
    private String id;
    private String text;
    private Long ver;
    
    public Clock toEntity(){
        return Clock.builder()
            .block_id(new ObjectId(id))
            .text(text)
            .ver(ver)
            .build();
    }
    
}
