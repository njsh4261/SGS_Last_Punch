package lastpunch.workspace.dto;

import java.time.LocalDateTime;
import java.util.Set;
import lastpunch.workspace.entity.AccountWorkspace;

public class WorkspaceWithMembersDto extends WorkspaceExportDto{
    private Set<AccountExportDto> accounts;
    WorkspaceWithMembersDto(Long id, String name, String description, Integer settings,
            String status, LocalDateTime createdt, LocalDateTime modifydt){
        super(id, name, description, settings, status, createdt, modifydt);
    }
}
