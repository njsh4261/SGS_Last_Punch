package lastpunch.workspace.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.dto.Members;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Message;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountChannelRepository;
import lastpunch.workspace.repository.AccountWorkspaceRepository;
import lastpunch.workspace.repository.channel.ChannelRepository;
import lastpunch.workspace.repository.message.MessageRepository;
import lastpunch.workspace.repository.workspace.WorkspaceRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
    private final MessageRepository messageRepository;
    
    private final CommonService commonService;
    
    private final DBExceptionMapper dbExceptionMapper;
    private Logger logger;
    
    @Autowired
    public WorkspaceService(
            WorkspaceRepository workspaceRepository,
            ChannelRepository channelRepository,
            AccountWorkspaceRepository accountWorkspaceRepository,
            AccountChannelRepository accountChannelRepository,
            MessageRepository messageRepository,
            CommonService commonService,
            DBExceptionMapper dbExceptionMapper){
        this.workspaceRepository = workspaceRepository;
        this.channelRepository = channelRepository;
        this.accountWorkspaceRepository = accountWorkspaceRepository;
        this.accountChannelRepository = accountChannelRepository;
        this.messageRepository = messageRepository;
        this.commonService = commonService;
        this.dbExceptionMapper = dbExceptionMapper;
        this.logger = LoggerFactory.getLogger(WorkspaceService.class);
    }
    
    public Map<String, Object> getList(Long userId, Pageable pageable){
        return Map.of("workspaces", workspaceRepository.getListWithUserId(userId, pageable));
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of(
                "workspace",
                commonService.getWorkspace(id).exportWithOwner(workspaceRepository.getOwnerOfWorkspace(id))
        );
    }

    public Map<String, Object> getAllMembers(Long workspaceId, Long userId){
        List<Account.ExportSimpleDto> members = workspaceRepository.getAllMembers(workspaceId);
        List<String> dmList = members.stream().map(
            exportSimpleDto -> getDMChannelId(userId, exportSimpleDto.getId())
        ).collect(Collectors.toList());
        
        Map<String, Message> messages = messageRepository.getRecentDMs(dmList);
        for(Account.ExportSimpleDto member: members){
            member.setLastMessage(
                messages.getOrDefault(getDMChannelId(userId, member.getId()), new Message())
            );
        }
        
        return Map.of("members", new Members(members));
    }

    public Map<String, Object> getMembersPaging(Long id, Pageable pageable){
        return Map.of("members", workspaceRepository.getMembersPaging(id, pageable));
    }

    private String getDMChannelId(Long userId1, Long userId2){
        return userId1 < userId2
            ? String.format("%d-%d", userId1, userId2)
            : String.format("%d-%d", userId2, userId1);
    }

    public Map<String, Object> getAllChannels(Long workspaceId, Long userId){
        return Map.of("channels", new Members(workspaceRepository.getAllChannels(workspaceId, userId)));
    }

    public Map<String, Object> getChannelsPaging(Long id, Pageable pageable){
        return Map.of("channels", workspaceRepository.getChannelsPaging(id, pageable));
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
    
    public Map<String, Object> edit(Workspace.EditDto editDto, Long id){
        workspaceRepository.save(editDto.toEntity(commonService.getWorkspace(id)));
        return new HashMap<>();
    }
    
    public Map<String, Object> delete(Long id){
        try{
            workspaceRepository.deleteById(id);
            return new HashMap<>();
        } catch(EmptyResultDataAccessException e){
            throw new BusinessException(StatusCode.WORKSPACE_NOT_EXIST);
        }
    }
}
