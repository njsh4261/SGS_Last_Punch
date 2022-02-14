package lastpunch.workspace.repository.channel;

import lastpunch.workspace.entity.Account.ExportDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ChannelRepositoryCustom{
    Page<ExportDto> getMembers(Long id, Pageable pageable);
    ExportDto getOwnerOfChannel(Long channelId);
}
