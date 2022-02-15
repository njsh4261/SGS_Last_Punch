package lastpunch.workspace.repository.channel;

import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.Channel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ChannelRepositoryCustom{
    Page<Account.ExportDto> getMembers(Long id, Pageable pageable);
    Account.ExportDto getOwnerOfChannel(Long channelId);
    Page<Channel.ExportSimpleDtoImpl> findByName(Long workspaceId, String name, Pageable pageable);
}
