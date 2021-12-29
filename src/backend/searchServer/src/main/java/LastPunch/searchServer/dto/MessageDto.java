package LastPunch.searchServer.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
@Document(indexName = "message_idx")
public class MessageDto {
    @Id
    private Integer id;
    private Integer channel_id;
    @Field(type = FieldType.Text)
    private String content;
    private Integer refer_reply_id;
    private Integer status;
    private LocalDateTime created_dt;
    private LocalDateTime modified_dt;
    private Integer reply_count;
    private LocalDateTime last_reply_dt;
}