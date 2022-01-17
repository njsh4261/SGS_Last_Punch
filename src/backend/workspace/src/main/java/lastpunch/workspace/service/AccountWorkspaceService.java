package lastpunch.workspace.service;

import lastpunch.workspace.entity.AccountWorkspace;
import org.springframework.stereotype.Service;

import lastpunch.workspace.repository.AccountWorkspaceRepository;

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
    
    public void addNewMember(AccountWorkspace.ImportDto accountWorkspaceDto){
        // TODO: query
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountWorkspaceRepository.save(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId()
        );
    }

    public void deleteMember(AccountWorkspace.ImportDto accountWorkspaceDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountWorkspaceRepository.delete(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId()
        );
    }
}
