package lastpunch.authserver.service;

import static lastpunch.authserver.common.jwt.JwtProvider.REFRESH_TOKEN_VALIDATION_SEC;

import java.util.Map;
import java.util.Optional;
import lastpunch.authserver.common.CustomUser;
import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.common.jwt.JwtProvider;
import lastpunch.authserver.dto.AccountInfo;
import lastpunch.authserver.dto.LoginRequest;
import lastpunch.authserver.dto.LoginResponse;
import lastpunch.authserver.entity.Account;
import lastpunch.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class LoginService {
    private final JwtProvider jwtProvider;
    private final AuthenticationManager authenticationManager;
    private final RedisService redisService;
    private final CustomUserDetailsService customUserDetailsService;
    private final AccountRepository accountRepository;
    
    @Transactional
    public LoginResponse login(LoginRequest loginRequest){
        UsernamePasswordAuthenticationToken authenticationToken =
            new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword());
        
        try {
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            UserDetails userDetails = customUserDetailsService.loadUserByUsername(loginRequest.getEmail());
            Long userId = ((CustomUser)userDetails).getAccount().getId();
            Account account = accountRepository.findById(userId);
            
            
            String accessToken = jwtProvider.createAccessToken(authentication, userId);
            String refreshToken = jwtProvider.createRefreshToken(authentication, userId);
            //redis에 refresh token 저장
            redisService.setData("RefreshToken:" + authentication.getName(), refreshToken, REFRESH_TOKEN_VALIDATION_SEC);
    
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
