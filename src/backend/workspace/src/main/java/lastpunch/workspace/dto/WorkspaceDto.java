package lastpunch.workspace.dto;

import javax.validation.constraints.NotBlank;
import lastpunch.workspace.entity.Workspace;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Data
@NoArgsConstructor
public class WorkspaceDto{
    private String name;
    private String description;
    private Integer settings;
    private Integer status; // TODO: converter 문제 해결 시 String으로

    public Workspace toEntity(){
        settings = (settings == null) ? 0 : settings;
        status = (status == null) ? 0 : status;
        return Workspace.builder()
            .name(name)
            .description(description)
            .settings(settings)
            .status(status)
            .build();
    }
    
    public Workspace changeValues(Workspace workspace){
        return Workspace.builder()
            .id(workspace.getId())
            .name((name == null) ? workspace.getName() : name)
            .description((description == null) ? workspace.getDescription() : description)
            .settings((settings == null) ? workspace.getSettings() : settings)
            .status((status == null) ? workspace.getStatus() : status)
            .createdt(workspace.getCreatedt())
            .modifydt(workspace.getModifydt())
            .build();
    }
}
