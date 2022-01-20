package lastpunch.authserver.service;

import static lastpunch.authserver.common.jwt.JwtProvider.REFRESH_TOKEN_VALIDATION_SEC;

import java.util.Map;
import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.common.jwt.JwtProvider;
import lastpunch.authserver.dto.LoginRequest;
import lastpunch.authserver.dto.Tokens;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class LoginService {
    private final JwtProvider jwtProvider;
    private final AuthenticationManager authenticationManager;
    private final RedisService redisService;
    
    @Transactional
    public Tokens login(LoginRequest loginRequest){
        UsernamePasswordAuthenticationToken authenticationToken =
            new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword());
        
        try {
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            String accessToken = jwtProvider.createAccessToken(authentication);
            String refreshToken = jwtProvider.createRefreshToken(authentication);
            //redis에 refresh token 저장
            redisService.setData("RefreshToken:" + authentication.getName(), refreshToken, REFRESH_TOKEN_VALIDATION_SEC);
    
            return Tokens.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
        }
        catch (BadCredentialsException e) {
            throw new BusinessException(ErrorCode.BAD_CREDENTIALS);
        }
    }
    
    public String reissue(Map<String, Object> requestHeader){
        String refreshToken = requestHeader.get("x-auth-token").toString();
        Authentication authentication = jwtProvider.getAuthentication(refreshToken);
        String redisToken = redisService.getData("RefreshToken:"+ authentication.getName());
        if (!refreshToken.equals(redisToken)) {
            throw new BusinessException(ErrorCode.INVALID_REFRESH_TOKEN);
        }
        String newAccessToken = jwtProvider.createAccessToken(authentication);
        return newAccessToken;
    }
    
    public void logout(Map<String, Object> requestHeader){
        String refreshToken = requestHeader.get("x-auth-token").toString();
        Authentication authentication = jwtProvider.getAuthentication(refreshToken);
        redisService.deleteData("RefreshToken:"+ authentication.getName());
    }
}
