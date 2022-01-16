package lastpunch.workspace.dto;

import lastpunch.workspace.entity.AccountWorkspace;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AccountWorkspaceDto{
    private Long accountId;
    private Long workspaceId;
}
