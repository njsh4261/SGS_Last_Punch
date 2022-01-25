package lastpunch.authserver.service;

import java.util.Optional;
import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.dto.SignupRequest;
import lastpunch.authserver.entity.Account;
import lastpunch.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class SignupService {
    private final AccountRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final RedisService redisService;
    
    @Transactional
    public void signup(SignupRequest signupRequest){
        signupRequest.setPassword(passwordEncoder.encode(signupRequest.getPassword()));
        
        Optional<Account> account = memberRepository.findByEmail(signupRequest.getEmail());
        if(account.isPresent()){
            throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
        }
        
        String verifyCode = redisService.getData(signupRequest.getEmail());
        if (verifyCode == null || !verifyCode.equals(signupRequest.getVerifyCode())){
            throw new BusinessException(ErrorCode.MODIFIED_EMAIL_VERIFY_DATA);
        }
        
        memberRepository.save(signupRequest.toEntity());
    }
}
