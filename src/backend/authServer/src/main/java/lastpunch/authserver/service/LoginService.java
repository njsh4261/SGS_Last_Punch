package lastpunch.authserver.service;

import static lastpunch.authserver.common.jwt.JwtProvider.REFRESH_TOKEN_VALIDATION_SEC;

import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.common.jwt.JwtProvider;
import lastpunch.authserver.dto.AccountInfo;
import lastpunch.authserver.dto.LoginRequest;
import lastpunch.authserver.dto.LoginResponse;
import lastpunch.authserver.entity.Account;
import lastpunch.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class LoginService {
    private final JwtProvider jwtProvider;
    private final RedisService redisService;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    
    @Transactional
    public LoginResponse login(LoginRequest loginRequest){
        try {
            Account account = accountRepository.findByEmail(loginRequest.getEmail()).get();
            // password check
            if (!passwordEncoder.matches(loginRequest.getPassword(), account.getPassword())){
                 throw new BusinessException(ErrorCode.BAD_CREDENTIALS);
            }
            
            String accessToken = jwtProvider.createAccessToken(account);
            String refreshToken = jwtProvider.createRefreshToken(account);
            //redis에 refresh token 저장
            redisService.setData("RefreshToken:" + account.getEmail(), refreshToken, REFRESH_TOKEN_VALIDATION_SEC);

            return LoginResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .accountInfo(new AccountInfo(account))
                .build();
        }
        catch (BadCredentialsException e) {
            throw new BusinessException(ErrorCode.BAD_CREDENTIALS);
        }
    }
}
