package LastPunch.searchServer.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
@Document(indexName = "user_idx")
public class UserDto {
    @Id
    private Integer id;
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
