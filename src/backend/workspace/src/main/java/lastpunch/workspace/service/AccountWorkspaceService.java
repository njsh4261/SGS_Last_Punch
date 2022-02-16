package lastpunch.workspace.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.entity.AccountWorkspace;
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
        try{
            // 해당 워크스페이스에 대한 요청자 권한 조회
            Optional<AccountWorkspace.Dto> requesterOptional = accountWorkspaceRepository.get(
                    requesterId, dtoImpl.getWorkspaceId()
            );
            if(requesterOptional.isEmpty()){
                throw new BusinessException(StatusCode.PERMISSION_DENIED);
            }

            // 변경 대상자 권한 조회
            Optional<AccountWorkspace.Dto> targetOptional = accountWorkspaceRepository.get(
                    dtoImpl.getAccountId(), dtoImpl.getWorkspaceId()
            );
            if(targetOptional.isEmpty()){
                throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
            }

            AccountWorkspace.Dto requesterInfo = requesterOptional.get();
            switch(RoleType.toEnum(requesterInfo.getRoleId())){
                case NORMAL_USER:
                    // NORMAL_USER는 워크스페이스에서 본인 혹은 다른 유저의 권한을 변경할 수 없음
                    throw new BusinessException(StatusCode.PERMISSION_DENIED);
                case ADMIN:
                    if(Objects.equals(dtoImpl.getAccountId(), requesterId)){
                        if(RoleType.toEnum(dtoImpl.getRoleId()) == RoleType.ADMIN){
                            // ADMIN은 본인을 OWNER로 변경할 수 없음
                            throw new BusinessException(StatusCode.PERMISSION_DENIED);
                        }
                    }
                    else{
                        if(RoleType.toEnum(targetOptional.get().getRoleId()) == RoleType.ADMIN
                                && RoleType.toEnum(dtoImpl.getRoleId()) == RoleType.NORMAL_USER){
                            // ADMIN은 다른 ADMIN을 NORMAL_USER로 변경할 수 없음
                            throw new BusinessException(StatusCode.PERMISSION_DENIED);
                        }
                    }
                    break;
                case OWNER:
                    if(!Objects.equals(dtoImpl.getAccountId(), requesterId)
                            && RoleType.toEnum(dtoImpl.getRoleId()) == RoleType.OWNER){
                        // 다른 사용자를 OWNER로 지정하는 경우, 본인을 ADMIN으로 변경
                        accountWorkspaceRepository.edit(
                                requesterId, dtoImpl.getWorkspaceId(), RoleType.ADMIN.getId()
                        );
                    }
                    break;
            }

            accountWorkspaceRepository.edit(
                dtoImpl.getAccountId(), dtoImpl.getWorkspaceId(), dtoImpl.getRoleId()
            );
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }

    public Map<String, Object> delete(Long accountId, Long workspaceId, Long requesterId){
        try{
            // 해당 워크스페이스에 대한 요청자 권한 조회
            Optional<AccountWorkspace.Dto> requesterOptional = accountWorkspaceRepository.get(requesterId, workspaceId);
            if(requesterOptional.isEmpty()){
                throw new BusinessException(StatusCode.PERMISSION_DENIED);
            }
            switch(RoleType.toEnum(requesterOptional.get().getRoleId())){
                case NORMAL_USER:
                    // NORMAL_USER는 다른 멤버 강퇴 불가
                    if(!Objects.equals(requesterId, accountId)){
                        throw new BusinessException(StatusCode.PERMISSION_DENIED);
                    }
                case ADMIN:
                    // 변경 대상자 권한 조회
                    Optional<AccountWorkspace.Dto> targetOptional = accountWorkspaceRepository.get(
                            accountId, workspaceId
                    );
                    if(targetOptional.isEmpty()){
                        throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
                    }
                    if(RoleType.toEnum(targetOptional.get().getRoleId()) != RoleType.NORMAL_USER
                            && !Objects.equals(requesterId, accountId)){
                        // ADMIN은 NORMAL_USER만 강퇴 가능
                        throw new BusinessException(StatusCode.PERMISSION_DENIED);
                    }
                case OWNER:
                    // 워크스페이스 소유자는 워크스페이스의 소유권을 다른 사용자에게 양도하기 전까지 나갈 수 없음
                    if(Objects.equals(requesterId, accountId)){
                        throw new BusinessException(StatusCode.CANNOT_EXIT_WORKSPACE);
                    }
            }
            if(accountWorkspaceRepository.delete(accountId, workspaceId) <= 0){
                throw new BusinessException(StatusCode.ACCOUNTWORKSPACE_NOT_EXIST);
            }
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
}
