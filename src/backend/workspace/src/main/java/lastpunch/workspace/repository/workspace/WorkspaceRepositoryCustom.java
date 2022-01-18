package lastpunch.workspace.repository.workspace;

import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Workspace;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface WorkspaceRepositoryCustom{
    Page<Workspace.ExportDto> getListWithUserId(Long id, Pageable pageable);
    Page<Account.ExportDto> getMembers(Long id, Pageable pageable);
    Page<Channel.ExportDto> getChannels(Long id, Pageable pageable);
}
