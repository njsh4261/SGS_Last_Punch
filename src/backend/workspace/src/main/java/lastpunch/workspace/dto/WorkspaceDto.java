package lastpunch.workspace.dto;

import javax.validation.constraints.NotBlank;
import lastpunch.workspace.entity.Workspace;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class WorkspaceDto{
    @NotBlank
    private String name;
    private String description;
    private Integer settings;
    private String status;

    public WorkspaceDto(String name, String description) {
        this.name = name;
        this.description = description;
        this.settings = 0;
        this.status = "DEFAULT";
    }

    public Workspace toEntity(){
        return Workspace.builder()
            .name(name)
            .description(description)
            .settings(settings)
            .status(status)
            .build();
    }
}
