package lastpunch.workspace.service;

import java.util.Map;

import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountChannelRepository;
import lastpunch.workspace.repository.AccountWorkspaceRepository;
import lastpunch.workspace.repository.channel.ChannelRepository;
import lastpunch.workspace.repository.workspace.WorkspaceRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class WorkspaceService{
    private final WorkspaceRepository workspaceRepository;
    private final ChannelRepository channelRepository;
    private final AccountWorkspaceRepository accountWorkspaceRepository;
    private final AccountChannelRepository accountChannelRepository;
    
    private final CommonService commonService;
    
    public WorkspaceService(
            WorkspaceRepository workspaceRepository,
            ChannelRepository channelRepository,
            AccountWorkspaceRepository accountWorkspaceRepository,
            AccountChannelRepository accountChannelRepository,
            CommonService commonService) {
        this.workspaceRepository = workspaceRepository;
        this.channelRepository = channelRepository;
        this.accountWorkspaceRepository = accountWorkspaceRepository;
        this.accountChannelRepository = accountChannelRepository;
        this.commonService = commonService;
    }
    
    public Map<String, Object> getList(Long id, Pageable pageable){
        return Map.of("workspaces", workspaceRepository.getListWithUserId(id, pageable));
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of("workspace", commonService.getWorkspace(id).export());
    }

    public Map<String, Object> getMembers(Long id, Pageable pageable){
        return Map.of("members", workspaceRepository.getMembers(id, pageable));
    }

    public Map<String, Object> getChannels(Long id, Pageable pageable){
        return Map.of("channels", workspaceRepository.getChannels(id, pageable));
    }

    public Map<String, Object> create(Long userId, Workspace.CreateDto workspaceDto){
        Workspace newWorkspace = workspaceRepository.save(workspaceDto.toWorkspaceEntity());
        Channel newChannel = channelRepository.save(
            workspaceDto.toChannelEntity(newWorkspace, commonService.getAccount(userId))
        );
        
        accountWorkspaceRepository.save(userId, newWorkspace.getId(), RoleType.OWNER.getId());
        accountChannelRepository.add(userId, newChannel.getId(), RoleType.OWNER.getId());
        
        return Map.of(
                "workspace", newWorkspace.export(),
                "channel", newChannel.export()
        );
    }
    
    public void edit(Workspace.EditDto editDto, Long id){
        workspaceRepository.save(editDto.toEntity(commonService.getWorkspace(id)));
    }
    
    public void delete(Long id){
        workspaceRepository.deleteById(id);
    }
}
