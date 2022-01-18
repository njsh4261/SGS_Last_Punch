package lastpunch.workspace.dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Data;

// frontend로 response로 account를 보낼 때 사용하는 DTO
// 비밀번호와 워크스페이스 목록 제외
@Data
@Builder
public class AccountExportDto{
    private Long id;
    private String email;
    private String name;
    private String displayname;
    private String description;
    private String phone;
    private String country;
    private String language;
    private Integer settings;
    private String status;
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
}
