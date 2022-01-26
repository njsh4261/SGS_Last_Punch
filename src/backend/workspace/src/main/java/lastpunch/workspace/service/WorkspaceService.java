package lastpunch.workspace.service;

import java.util.Map;

import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountChannelRepository;
import lastpunch.workspace.repository.AccountWorkspaceRepository;
import lastpunch.workspace.repository.channel.ChannelRepository;
import lastpunch.workspace.repository.workspace.WorkspaceRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class WorkspaceService{
    private final WorkspaceRepository workspaceRepository;
    private final ChannelRepository channelRepository;
    private final AccountWorkspaceRepository accountWorkspaceRepository;
    private final AccountChannelRepository accountChannelRepository;
    
    private final CommonService commonService;
    
    private final DBExceptionMapper dbExceptionMapper;
    private Logger logger;
    
    public WorkspaceService(
        WorkspaceRepository workspaceRepository,
        ChannelRepository channelRepository,
        AccountWorkspaceRepository accountWorkspaceRepository,
        AccountChannelRepository accountChannelRepository,
        CommonService commonService,
        DBExceptionMapper dbExceptionMapper){
        this.workspaceRepository = workspaceRepository;
        this.channelRepository = channelRepository;
        this.accountWorkspaceRepository = accountWorkspaceRepository;
        this.accountChannelRepository = accountChannelRepository;
        this.commonService = commonService;
        this.dbExceptionMapper = dbExceptionMapper;
        this.logger = LoggerFactory.getLogger(WorkspaceService.class);
    }
    
    public Map<String, Object> getList(Long userId, Pageable pageable){
        return Map.of("workspaces", workspaceRepository.getListWithUserId(userId, pageable));
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
        try{
            commonService.getAccount(userId); // userId validation 용도의 호출
            Workspace newWorkspace = workspaceRepository.save(workspaceDto.toWorkspaceEntity());
            Channel newChannel = channelRepository.save(
                workspaceDto.toChannelEntity(newWorkspace)
            );
            accountWorkspaceRepository.add(userId, newWorkspace.getId(), RoleType.OWNER.getId());
            accountChannelRepository.add(userId, newChannel.getId(), RoleType.OWNER.getId());
            return Map.of(
                "workspace", newWorkspace.export(),
                "channel", newChannel.export()
            );
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
    
    public void edit(Workspace.EditDto editDto, Long id){
        workspaceRepository.save(editDto.toEntity(commonService.getWorkspace(id)));
    }
    
    public void delete(Long id){
        try{
            workspaceRepository.deleteById(id);
        } catch(EmptyResultDataAccessException e){
            throw new BusinessException(StatusCode.WORKSPACE_NOT_EXIST);
        }
    }
}
