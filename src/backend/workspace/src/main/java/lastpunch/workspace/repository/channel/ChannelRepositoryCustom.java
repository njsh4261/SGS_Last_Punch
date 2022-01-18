package lastpunch.workspace.repository.channel;

import lastpunch.workspace.entity.Account;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ChannelRepositoryCustom{
    Page<Account.ExportDto> getMembers(Long id, Pageable pageable);
}
