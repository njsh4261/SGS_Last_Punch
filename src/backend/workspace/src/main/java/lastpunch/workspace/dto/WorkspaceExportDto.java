package lastpunch.workspace.dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Data;

// frontend로 response로 workspace를 보낼 때 사용하는 DTO
// 멤버 목록 제외
@Data
@Builder
public class WorkspaceExportDto{
    private Long id;
    private String name;
    private String description;
    private Integer settings;
    private String status;
    private LocalDateTime createdt;
    private LocalDateTime modifydt;
}
