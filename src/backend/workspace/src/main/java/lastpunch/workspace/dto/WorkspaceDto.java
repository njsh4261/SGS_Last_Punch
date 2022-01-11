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
    
    public Workspace toEntity(){
        return Workspace.builder()
            .name(name)
            .description(description)
            .build();
    }
}
