package lastpunch.workspace.service;

import java.util.HashMap;
import java.util.Map;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.repository.AccountChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

@Service
public class AccountChannelService{
    private final AccountChannelRepository accountChannelRepository;
    private final DBExceptionMapper dbExceptionMapper;

    @Autowired
    public AccountChannelService(
            AccountChannelRepository accountChannelRepository,
            DBExceptionMapper dbExceptionMapper) {
        this.accountChannelRepository = accountChannelRepository;
        this.dbExceptionMapper = dbExceptionMapper;
    }

    public Map<String, Object> add(AccountChannel.Dto accountChannelDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        try{
            if(accountChannelDto.getRoleId() == null){
                accountChannelDto.setRoleId(RoleType.NORMAL_USER.getId());
            }
            accountChannelRepository.add(
                accountChannelDto.getAccountId(),
                accountChannelDto.getChannelId(),
                accountChannelDto.getRoleId()
            );
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }

    public Map<String, Object> edit(AccountChannel.Dto accountChannelDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        try{
            Integer editedRecords = accountChannelRepository.edit(
                accountChannelDto.getAccountId(),
                accountChannelDto.getChannelId(),
                accountChannelDto.getRoleId()
            );
            if(editedRecords <= 0){
                throw new BusinessException(StatusCode.ACCOUNTCHANNEL_NOT_EXIST);
            }
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }

    public Map<String, Object> delete(Long accountId, Long workspaceId){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        try{
            Integer deletedRecords = accountChannelRepository.delete(accountId, workspaceId);
            if(deletedRecords <= 0){
                throw new BusinessException(StatusCode.ACCOUNTCHANNEL_NOT_EXIST);
            }
            return new HashMap<>();
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
}
