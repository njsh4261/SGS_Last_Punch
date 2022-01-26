package lastpunch.workspace.service;

import java.util.Map;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class AccountService{
    private final AccountRepository accountRepository;
    
    @Autowired
    public AccountService(AccountRepository accountRepository){
        this.accountRepository = accountRepository;
    }
    
    public Map<String, Object> getByEmail(String email, Pageable pageable){
        return Map.of(
            "accounts",
            accountRepository.findByEmailContaining(email, pageable)
                .map(Account::export)
        );
    }
}
