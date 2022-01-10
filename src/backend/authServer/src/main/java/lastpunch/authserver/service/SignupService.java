package lastpunch.authserver.service;

import java.util.Optional;
import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
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
        
        Optional<Member> member = memberRepository.findByEmail(signupRequest.getEmail());
        if(member.isPresent()){
            throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
        }
        memberRepository.save(signupRequest.toEntity());
    }
}
