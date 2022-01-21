package lastpunch.workspace.service;

import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.repository.AccountChannelRepository;
import lastpunch.workspace.repository.channel.ChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class ChannelService{
    private final ChannelRepository channelRepository;
    private final AccountChannelRepository accountChannelRepository;
    
    private final CommonService commonService;
    
    @Autowired
    public ChannelService(
            ChannelRepository channelRepository,
            AccountChannelRepository accountChannelRepository,
            CommonService commonService){
        this.channelRepository = channelRepository;
        this.accountChannelRepository = accountChannelRepository;
        this.commonService = commonService;
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of("channel", commonService.getChannel(id).export());
    }
    
    public Object getMembers(Long id, Pageable pageable){
        return Map.of("members", channelRepository.getMembers(id, pageable));
    }
    
    public Map<String, Object> create(Long userId, Channel.CreateDto createDto){
        Channel newChannel = channelRepository.save(
            createDto.toEntity(
                commonService.getWorkspace(createDto.getWorkspaceId()),
                commonService.getAccount(userId)
            )
        );
    
        accountChannelRepository.add(userId, newChannel.getId(), RoleType.OWNER.getId());
        
        return Map.of("channel", newChannel.export());
    }
    
    public void edit(Long id, Channel.EditDto editDto){
        channelRepository.save(editDto.toEntity(commonService.getChannel(id)));
    }
    
    public void delete(Long id){
        channelRepository.deleteById(id);
    }
}
