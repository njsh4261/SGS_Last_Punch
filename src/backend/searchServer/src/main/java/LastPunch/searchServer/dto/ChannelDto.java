package LastPunch.searchServer.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
@Document(indexName = "channel_idx")
public class ChannelDto {
    @Id
    private Integer id;
    private Integer workspace_id;
    private Integer creator_id;
    private String name;
    private String topic;
    private String description;
    private Integer settings;
    private Integer status;
    private LocalDateTime created_dt;
    private LocalDateTime modified_dt;
}
