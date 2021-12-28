package LastPunch.searchServer.document;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.time.LocalDateTime;

@Setter
@Getter
@ToString
@Document(indexName = "mysql_idx")
public class User {
    @Id
    private Long user_id;
    private String username;
    private String password;
    private String email;
    private Long role;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean disabled;
}
