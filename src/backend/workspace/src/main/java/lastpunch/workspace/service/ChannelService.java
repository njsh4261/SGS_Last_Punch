package lastpunch.workspace.service;

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
    
    public Map<String, Object> create(Channel.CreateDto createDto){
        Channel newChannel = channelRepository.save(
            createDto.toEntity(
                commonService.getWorkspace(createDto.getWorkspaceId()),
                commonService.getAccount(createDto.getCreatorId())
            )
        );
    
        // TODO: creator id를 header에서 가져온다면 코드를 수정
        // TODO: 권한 관련 부분 수정할 때 하드코딩한 roleId 수정
        accountChannelRepository.add(createDto.getCreatorId(), newChannel.getId(), 2L);
        
        return Map.of("channel", newChannel.export());
    }
    
    public void edit(Long id, Channel.EditDto editDto){
        channelRepository.save(editDto.toEntity(commonService.getChannel(id)));
    }
    
    public void delete(Long id){
        channelRepository.deleteById(id);
    }
}
