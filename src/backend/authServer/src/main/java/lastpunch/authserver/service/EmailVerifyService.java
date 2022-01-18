package lastpunch.authserver.service;

import java.util.Random;
import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import lastpunch.authserver.dto.SignupRequest;
import lastpunch.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailVerifyService {
    @Autowired
    private JavaMailSender javaMailSender;
    private final AccountRepository accountRepository;
//    private final RedisService redisService;
//    private final UserRepository userRepository;
    
    public void sendMail(String to, String sub, String text){
        MimeMessage message = javaMailSender.createMimeMessage();
        try {
            message.setSubject(sub, "UTF-8");
            message.setText(text, "UTF-8", "html");
            message.setFrom("lastpunch@snack.com");
            message.setRecipient(RecipientType.TO, new InternetAddress(to));
            javaMailSender.send(message);
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    @Async
    public void sendVerifyMail(SignupRequest signupRequest) {
        // 랜덤 6자리 숫자 생성
        Random random = new Random();
        int number = random.nextInt(999999);
        String verifyCode = String.format("%06d", number);
    
        //redis에 인증 코드 6자리 저장
        //        redisService.setData(verifyCode, signupRequest.getEmail(),  1000 * 60 * 5);
        
        String sub = "Snack 회원가입 인증 코드를 발송해드립니다.";
        String text = "<h1>인증코드: " + verifyCode + "</h1>" + "<p>Snack으로 돌아가 6자리 인증 코드를 입력해주세요.</p>";
        sendMail(signupRequest.getEmail(), sub, text);
    }
    
    public void verifyMail(String key) throws RuntimeException {
//        String username = redisService.getData(key);
        Account account = accountRepository.findByEmail()
        User user = userRepository.findByUsername(username);
        if(user==null) throw new RuntimeException("존재하지 않는 유저입니다.");
        user.setRole("ROLE_USER");
        userRepository.save(user);
        redisService.deleteData(key);
    }
}
