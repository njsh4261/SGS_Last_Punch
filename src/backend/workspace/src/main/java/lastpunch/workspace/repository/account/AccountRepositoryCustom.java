package lastpunch.workspace.repository.account;

import java.util.List;
import lastpunch.workspace.entity.Account.ExportDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface AccountRepositoryCustom{
    public Page<ExportDto> getMembersOfWorkspace(Long workspaceId, Pageable pageable);
    public Page<ExportDto> getMembersOfChannel(Long channelId, Pageable pageable);
}
