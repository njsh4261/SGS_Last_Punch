package lastpunch.authserver.service;

import static lastpunch.authserver.common.jwt.JwtProvider.REFRESH_TOKEN_VALIDATION_SEC;

import java.util.Map;
import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.common.jwt.JwtProvider;
import lastpunch.authserver.entity.Account;
import lastpunch.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class AuthService {
    private final JwtProvider jwtProvider;
    private final AuthenticationManager authenticationManager;
    private final RedisService redisService;
    private final AccountRepository accountRepository;
    
    public String reissue(Map<String, Object> requestHeader){
        String refreshToken = requestHeader.get("x-auth-token").toString();
        Long userId = jwtProvider.getUserId(refreshToken);
        Account account = accountRepository.findById(userId);
        
        String redisToken = redisService.getData("RefreshToken:"+ account.getEmail());
        if (!refreshToken.equals(redisToken)) {
            throw new BusinessException(ErrorCode.INVALID_REFRESH_TOKEN);
        }

        return jwtProvider.createAccessToken(account);
    }
    
    public void logout(Map<String, Object> requestHeader){
        String refreshToken = requestHeader.get("x-auth-token").toString();
        redisService.deleteData("RefreshToken:"+ jwtProvider.getEmail(refreshToken));
    }
}
