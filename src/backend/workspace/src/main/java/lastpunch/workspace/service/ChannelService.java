package lastpunch.workspace.service;

import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.repository.channel.ChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;

@Service
public class ChannelService{
    private final ChannelRepository channelRepository;
    private final CommonService commonService;
    
    @Autowired
    public ChannelService(ChannelRepository channelRepository, CommonService commonService){
        this.channelRepository = channelRepository;
        this.commonService = commonService;
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of("channel", commonService.getChannel(id).export());
    }
    
    public Object getMembers(Long id, Pageable pageable){
        return Map.of("members", channelRepository.getMembers(id, pageable));
    }
    
    public void create(Channel.ImportDto channelImportDto){
        channelRepository.save(
                Channel.builder()
                        .workspace(commonService.getWorkspace(channelImportDto.getWorkspaceId()))
                        .account(commonService.getAccount(channelImportDto.getCreatorId()))
                        .name(channelImportDto.getName())
                        .topic(channelImportDto.getTopic())
                        .description(channelImportDto.getDescription())
                        .settings(channelImportDto.getSettings())
                        .status(channelImportDto.getStatus())
                        .createdt(LocalDateTime.now())
                        .modifydt(LocalDateTime.now())
                        .build()
        );
    }
    
    public void edit(Long id, Channel.ImportDto channelImportDto){
        Channel channel = commonService.getChannel(id);
        if(channelImportDto.getName() != null){
            channel.setName(channelImportDto.getName());
        }
        if(channelImportDto.getTopic() != null){
            channel.setTopic(channelImportDto.getTopic());
        }
        if(channelImportDto.getDescription() != null){
            channel.setDescription(channelImportDto.getDescription());
        }
        if(channelImportDto.getSettings() != null){
            channel.setSettings(channelImportDto.getSettings());
        }
        if(channelImportDto.getStatus() != null){
            channel.setStatus(channelImportDto.getStatus());
        }
        channelRepository.save(channel);
    }
    
    public void delete(Long id){
        channelRepository.deleteById(id);
    }
}
