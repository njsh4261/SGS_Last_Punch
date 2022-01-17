package lastpunch.workspace.service;

import java.util.Optional;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountRepository;
import lastpunch.workspace.repository.WorkspaceRepository;
import org.springframework.stereotype.Service;

@Service
public class CommonService{
    private final WorkspaceRepository workspaceRepository;
    private final AccountRepository accountRepository;
    
    public CommonService(
            WorkspaceRepository workspaceRepository, AccountRepository accountRepository){
        this.workspaceRepository = workspaceRepository;
        this.accountRepository = accountRepository;
    }
    
    public Workspace getWorkspace(Long id){
        Optional<Workspace> workspaceOptional = workspaceRepository.findById(id);
        if(workspaceOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_NOT_EXIST);
        }
        return workspaceOptional.get();
    }
    
    public Account getAccount(Long id){
        Optional<Account> accountOptional = accountRepository.findById(id);
        if(accountOptional.isEmpty()){
            throw new BusinessException(StatusCode.ACCOUNT_NOT_EXIST);
        }
        return accountOptional.get();
    }
}
