package lastpunch.authserver.service;

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
    
    @Transactional
    public Tokens login(LoginRequest loginRequest){
        UsernamePasswordAuthenticationToken authenticationToken =
            new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword());
        
        try {
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            String accessToken = jwtProvider.createAccessToken(authentication);
            String refreshToken = jwtProvider.createRefreshToken(authentication);
//            redisService.setData("RefreshToken:" + authentication.getName(), refreshToken, REFRESH_TOKEN_VALIDATION_SEC);
    
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
        String refreshToken = requestHeader.get("refresh_token").toString();
        Authentication authentication = jwtProvider.getAuthentication(refreshToken);
        String newAccessToken = jwtProvider.createAccessToken(SecurityContextHolder.getContext().getAuthentication());
        return newAccessToken;
    }
}
