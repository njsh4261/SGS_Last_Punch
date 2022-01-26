package lastpunch.workspace.service;

import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.repository.AccountWorkspaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

@Service
public class AccountWorkspaceService{
    private final AccountWorkspaceRepository accountWorkspaceRepository;
    private final DBExceptionMapper dbExceptionMapper;

    @Autowired
    public AccountWorkspaceService(
            AccountWorkspaceRepository accountWorkspaceRepository,
            DBExceptionMapper dbExceptionMapper){
        this.accountWorkspaceRepository = accountWorkspaceRepository;
        this.dbExceptionMapper = dbExceptionMapper;
    }
    
    public void add(AccountWorkspace.Dto accountWorkspaceDto){
        try{
            // TODO: 요청자의 권한에 따라 거부하는 코드 추가
            if(accountWorkspaceDto.getRoleId() == null){
                accountWorkspaceDto.setRoleId(RoleType.NORMAL_USER.getId());
            }
            accountWorkspaceRepository.add(
                accountWorkspaceDto.getAccountId(),
                accountWorkspaceDto.getWorkspaceId(),
                accountWorkspaceDto.getRoleId()
            );
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
    
    public void edit(AccountWorkspace.Dto accountWorkspaceDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        try{
            Integer editedRecords = accountWorkspaceRepository.edit(
                accountWorkspaceDto.getAccountId(),
                accountWorkspaceDto.getWorkspaceId(),
                accountWorkspaceDto.getRoleId()
            );
            if(editedRecords <= 0){
                throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
            }
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }

    public void delete(AccountWorkspace.Dto accountWorkspaceDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        Integer deletedRecords = accountWorkspaceRepository.delete(
            accountWorkspaceDto.getAccountId(),
            accountWorkspaceDto.getWorkspaceId()
        );
        if(deletedRecords <= 0){
            throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
        }
    }
}
