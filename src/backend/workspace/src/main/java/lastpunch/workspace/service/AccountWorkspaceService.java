package lastpunch.workspace.service;

import java.util.concurrent.ConcurrentHashMap;
import lastpunch.workspace.dto.AccountWorkspaceDto;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountRepository;
import lastpunch.workspace.repository.AccountWorkspaceRepository;
import lastpunch.workspace.repository.WorkspaceRepository;
import org.springframework.stereotype.Service;

@Service
public class AccountWorkspaceService{
    private final CommonService commonService;
    private final AccountWorkspaceRepository accountWorkspaceRepository;
    
    private static final String ACCOUNT = "account";
    private static final String WORKSPACE = "workspace";
    
    public AccountWorkspaceService(
            CommonService commonService,
            AccountWorkspaceRepository accountWorkspaceRepository){
        this.commonService = commonService;
        this.accountWorkspaceRepository = accountWorkspaceRepository;
    }
    
    public void addNewMember(AccountWorkspaceDto accountWorkspaceDto){
        // TODO: query
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountWorkspaceRepository.save(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId()
        );
    }

    public void deleteMember(AccountWorkspaceDto accountWorkspaceDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountWorkspaceRepository.delete(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId()
        );
    }
}
