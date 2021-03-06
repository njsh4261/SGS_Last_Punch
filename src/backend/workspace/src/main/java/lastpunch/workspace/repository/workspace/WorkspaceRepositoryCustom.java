package lastpunch.workspace.repository.workspace;

import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Workspace;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface WorkspaceRepositoryCustom{
    Page<Workspace.ExportDto> getListWithUserId(Long id, Pageable pageable);
    List<Account.ExportSimpleDto> getAllMembers(Long id);
    Page<Account.ExportDto> getMembersPaging(Long id, Pageable pageable);
    Page<Channel.ExportDto> getChannelsPaging(Long id, Pageable pageable);
    Account.ExportDto getOwnerOfWorkspace(Long workspaceId);
}
