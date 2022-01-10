package lastpunch.authserver.service;

import java.util.Optional;
import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.common.jwt.JwtProvider;
import lastpunch.authserver.dto.LoginRequest;
import lastpunch.authserver.dto.SignupRequest;
import lastpunch.authserver.dto.Tokens;
import lastpunch.authserver.entity.Member;
import lastpunch.authserver.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class LoginService {
    private final JwtProvider jwtProvider;
    private final MemberRepository memberRepository;
    private final AuthenticationManager authenticationManager;
    
    @Transactional
    public Tokens login(LoginRequest loginRequest){
        UsernamePasswordAuthenticationToken authenticationToken =
            new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword());
        Authentication authentication = authenticationManager.authenticate(authenticationToken);

        String accessToken = jwtProvider.createAccessToken(authentication);
        String refreshToken = jwtProvider.createRefreshToken(authentication);
//
//        redisService.setData("RefreshToken:" + authentication.getName(), refreshToken, REFRESH_TOKEN_VALIDATION_SEC);
        
        return Tokens.builder()
            .accessToken(accessToken)
            .refreshToken(refreshToken)
            .build();
    }
    
    
}
