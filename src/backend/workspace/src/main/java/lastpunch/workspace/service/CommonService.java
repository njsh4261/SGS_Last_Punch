package lastpunch.workspace.service;

import java.util.Optional;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountRepository;
import lastpunch.workspace.repository.ChannelRepository;
import lastpunch.workspace.repository.WorkspaceRepository;
import org.springframework.stereotype.Service;

@Service
public class CommonService{
    private final WorkspaceRepository workspaceRepository;
    private final AccountRepository accountRepository;
    private final ChannelRepository channelRepository;
    
    public CommonService(
            WorkspaceRepository workspaceRepository,
            AccountRepository accountRepository,
            ChannelRepository channelRepository){
        this.workspaceRepository = workspaceRepository;
        this.accountRepository = accountRepository;
        this.channelRepository = channelRepository;
    }
    
    public Workspace getWorkspace(Long id){
        Optional<Workspace> workspaceOptional = workspaceRepository.findById(id);
        if(workspaceOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_WS_NOT_EXIST);
        }
        return workspaceOptional.get();
    }
    
    public Account getAccount(Long id){
        Optional<Account> accountOptional = accountRepository.findById(id);
        if(accountOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_AC_NOT_EXIST);
        }
        return accountOptional.get();
    }
    
    public Channel getChannel(Long id){
        Optional<Channel> channelOptional = channelRepository.findById(id);
        if(channelOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_CN_NOT_EXIST);
        }
        return channelOptional.get();
    }
}
