package lastpunch.authserver.service;

import static lastpunch.authserver.common.jwt.JwtProvider.REFRESH_TOKEN_VALIDATION_SEC;

import java.util.Map;
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
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class AuthService {
    private final JwtProvider jwtProvider;
    private final AuthenticationManager authenticationManager;
    private final RedisService redisService;
    private final CustomUserDetailsService customUserDetailsService;
    private final AccountRepository accountRepository;
    
    public String reissue(Map<String, Object> requestHeader){
        String refreshToken = requestHeader.get("x-auth-token").toString();
        Authentication authentication = jwtProvider.getAuthentication(refreshToken);
        String redisToken = redisService.getData("RefreshToken:"+ authentication.getName());
        if (!refreshToken.equals(redisToken)) {
            throw new BusinessException(ErrorCode.INVALID_REFRESH_TOKEN);
        }
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(authentication.getName());
        Long userId = ((CustomUser)userDetails).getAccount().getId();
        String newAccessToken = jwtProvider.createAccessToken(authentication, userId);
        return newAccessToken;
    }
    
    public void logout(Map<String, Object> requestHeader){
        String refreshToken = requestHeader.get("x-auth-token").toString();
        Authentication authentication = jwtProvider.getAuthentication(refreshToken);
        redisService.deleteData("RefreshToken:"+ authentication.getName());
    }
}
