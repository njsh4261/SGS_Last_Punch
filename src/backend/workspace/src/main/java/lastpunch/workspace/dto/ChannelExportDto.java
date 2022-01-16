package lastpunch.workspace.dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Data;

// frontend response로 channel을 보낼 때 사용하는 DTO
@Data
@Builder
public class ChannelExportDto{
    private Long id;
    private Long workspaceId; // TODO: 필요에 따라 WorkspaceExportDto로 변경
    private AccountExportDto account; // TODO: 필요에 따라 더 적은 정보만을 전달
    private String name;
    private String topic;
    private String description;
    private Integer settings;
    private Integer status;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
}
