package lastpunch.workspace.repository.workspace;

import java.util.List;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.entity.Workspace.ExportDto;

public interface WorkspaceRepositoryCustom{
    public ExportDto getOneWorkspace(Long id);
}
