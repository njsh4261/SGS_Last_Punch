package lastpunch.workspace.service;

import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.dto.AccountWorkspaceDto;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountRepository;
import lastpunch.workspace.repository.WorkspaceRepository;
import org.springframework.stereotype.Service;

@Service
public class AccountWorkspaceService{
    private final AccountRepository accountRepository;
    private final WorkspaceRepository workspaceRepository;
    
    private static final String ACCOUNT = "account";
    private static final String WORKSPACE = "workspace";
    
    public AccountWorkspaceService(
        AccountRepository accountRepository, WorkspaceRepository workspaceRepository){
        this.accountRepository = accountRepository;
        this.workspaceRepository = workspaceRepository;
    }
    
    private ConcurrentHashMap<String, Object> getAccountAndWorkspace(AccountWorkspaceDto dto){
        ConcurrentHashMap<String, Object> hashMap = new ConcurrentHashMap<>();
        
        Optional<Account> accountOptional = accountRepository.findById(dto.getAccountId());
        if(accountOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_AC_NOT_EXIST);
        }
    
        Optional<Workspace> workspaceOptional = workspaceRepository.findById(dto.getWorkspaceId());
        if(workspaceOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_WS_NOT_EXIST);
        }
        
        hashMap.put(ACCOUNT, accountOptional.get());
        hashMap.put(WORKSPACE, workspaceOptional.get());
        return hashMap;
    }
    
    public Workspace addNewMember(AccountWorkspaceDto accountWorkspaceDto){
        ConcurrentHashMap<String, Object> hashMap = getAccountAndWorkspace(accountWorkspaceDto);
        
        Account account = (Account) hashMap.get(ACCOUNT);
        Workspace workspace = (Workspace) hashMap.get(WORKSPACE);
        
        workspace.getAccounts().add(
            AccountWorkspace.builder()
                .account(account)
                .workspace(workspace)
                .build()
        );
        return workspaceRepository.save(workspace);
    }

    public void deleteMember(AccountWorkspaceDto accountWorkspaceDto){
        ConcurrentHashMap<String, Object> hashMap = getAccountAndWorkspace(accountWorkspaceDto);
    
        Account account = (Account) hashMap.get(ACCOUNT);
        Workspace workspace = (Workspace) hashMap.get(WORKSPACE);
    
        workspace.getAccounts().remove(
            AccountWorkspace.builder()
                .account(account)
                .workspace(workspace)
                .build()
        );
    }
}
