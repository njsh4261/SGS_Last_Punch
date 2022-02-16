package lastpunch.workspace.service;

import java.util.HashMap;
import java.util.Map;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.AccountWorkspace.DtoImpl;
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
    
    public Map<String, Object> add(DtoImpl dtoImpl){
        try{
            // TODO: 요청자의 권한에 따라 거부하는 코드 추가
            accountWorkspaceRepository.add(
                dtoImpl.getAccountId(),
                dtoImpl.getWorkspaceId(),
                dtoImpl.getRoleId() != null ? dtoImpl.getRoleId() : RoleType.NORMAL_USER.getId()
            );
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
    
    public Map<String, Object> edit(DtoImpl dtoImpl, Long requesterId){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        try{
            Integer editedRecords = accountWorkspaceRepository.edit(
                dtoImpl.getAccountId(), dtoImpl.getWorkspaceId(), dtoImpl.getRoleId()
            );
            if(editedRecords <= 0){
                throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
            }
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }

    public Map<String, Object> delete(Long accountId, Long workspaceId, Long requesterId){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        try{
            Integer deletedRecords = accountWorkspaceRepository.delete(accountId, workspaceId);
            if(deletedRecords == 0){
                throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
            }
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
}
