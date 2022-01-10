package lastpunch.authserver.service;

import lastpunch.authserver.dto.SignupRequest;
import lastpunch.authserver.entity.Member;
import lastpunch.authserver.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class SignupService {
    private final MemberRepository memberRepository;
    
    @Transactional
    public void signup(SignupRequest signupRequest){
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        signupRequest.setPassword(passwordEncoder.encode(signupRequest.getPassword()));
        memberRepository.save(signupRequest.toEntity());
    }
}
