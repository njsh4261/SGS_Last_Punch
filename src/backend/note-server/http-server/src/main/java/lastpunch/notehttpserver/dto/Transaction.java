package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import lastpunch.notehttpserver.entity.Block;
import lombok.Data;

@Data
public class Transaction {
    private String op;
    private String id;
    private String type;
    private String content;
    private String parentBlockId;
    private LocalDateTime lastModifyDt;
    private Long lastWriter;
    
    public Block getBlock(){
        return Block.builder()
            .id(id)
            .type(type)
            .content(content)
            .parentBlockId(parentBlockId)
            .lastModifyDt(lastModifyDt)
            .lastWriter(lastWriter)
            .build();
    }
}
