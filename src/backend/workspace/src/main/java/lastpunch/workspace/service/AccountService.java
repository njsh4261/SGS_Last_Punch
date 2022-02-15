package lastpunch.workspace.service;

import java.util.Map;

import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.repository.account.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class AccountService{
    private final AccountRepository accountRepository;
    private final CommonService commonService;
    
    @Autowired
    public AccountService(AccountRepository accountRepository, CommonService commonService){
        this.accountRepository = accountRepository;
        this.commonService = commonService;
    }
    
    public Map<String, Object> getSelf(Long id){
        return Map.of(
            "account", commonService.getAccount(id).export()
        );
    }

    // 이메일 contains 조건으로 account 검색 (본인 제외)
    public Map<String, Object> getByEmail(String email, Pageable pageable, Long id){
        if(email == null){
            throw new BusinessException(StatusCode.INVALID_PARAMETERS);
        }
        return Map.of(
            "accounts", accountRepository.findByEmail(email, pageable, id)
        );
    }
}
