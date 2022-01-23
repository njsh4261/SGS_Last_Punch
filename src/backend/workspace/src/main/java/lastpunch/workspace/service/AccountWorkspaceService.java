package lastpunch.workspace.service;

import lastpunch.workspace.entity.AccountWorkspace;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lastpunch.workspace.repository.AccountWorkspaceRepository;

@Service
public class AccountWorkspaceService{
    private final AccountWorkspaceRepository accountWorkspaceRepository;
    
    private static final String ACCOUNT = "account";
    private static final String WORKSPACE = "workspace";

    @Autowired
    public AccountWorkspaceService(AccountWorkspaceRepository accountWorkspaceRepository){
        this.accountWorkspaceRepository = accountWorkspaceRepository;
    }
    
    public void addMember(AccountWorkspace.Dto accountWorkspaceDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountWorkspaceRepository.save(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId(),
            accountWorkspaceDto.getRoleId()
        );
    }

    public void deleteMember(AccountWorkspace.Dto accountWorkspaceDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountWorkspaceRepository.delete(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId()
        );
    }
}
