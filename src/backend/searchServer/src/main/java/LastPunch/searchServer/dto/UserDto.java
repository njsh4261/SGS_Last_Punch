package LastPunch.searchServer.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.time.LocalDateTime;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
@Document(indexName = "user_idx")
public class UserDto {
    @Id
    private Integer id;
    @Field(type = FieldType.Integer, name = "workspaceId")
    private Integer workspaceId;
    private Integer channel_id;
    private String email;
    private String password;
    private Integer login_type;
    private String name;
    private String display_name;
    private String role_desc;
    private String phone_number;
    private String country_code;
    private Integer status;
    private Integer membership_level;
    private Integer membership_point;
    private LocalDateTime created_dt;
    private LocalDateTime modified_dt;
    private LocalDateTime last_login_dt;
}
