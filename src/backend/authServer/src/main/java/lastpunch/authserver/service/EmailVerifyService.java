package lastpunch.authserver.service;

import lastpunch.authserver.common.exception.BusinessException;
import lastpunch.authserver.common.exception.ErrorCode;
import lastpunch.authserver.dto.EmailVerifyRequest;
import lastpunch.authserver.entity.Account;
import lastpunch.authserver.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Optional;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class EmailVerifyService {
    @Autowired
    private JavaMailSender javaMailSender;
    private final RedisService redisService;
    private final AccountRepository accountRepository;
    
    public void sendMail(String to, String sub, String text){
        MimeMessage message = javaMailSender.createMimeMessage();
        try {
            message.setSubject(sub, "UTF-8");
            message.setText(text, "UTF-8", "html");
            message.setFrom(new InternetAddress("lastpunch@snack.com", "SNACK"));
            message.setRecipient(RecipientType.TO, new InternetAddress(to));
            javaMailSender.send(message);
        }
        catch(Exception e){
            throw new BusinessException(ErrorCode.MAIL_SEND_ERROR);
        }
    }
    
    @Async
    public void sendVerifyMail(String email) {
        // 랜덤 6자리 숫자 생성
        Random random = new Random();
        int number = random.nextInt(999999);
        String verifyCode = String.format("%06d", number);
    
        // redis에 인증 코드 6자리 저장 - 유효시간 5분
        redisService.setData(email, verifyCode,  1000 * 60 * 5);
        
        String sub = "Snack 회원가입 인증 코드를 발송해드립니다.";
        String text = "<h1>인증코드: " + verifyCode + "</h1>" + "<p>Snack으로 돌아가 6자리 인증 코드를 입력해주세요.</p>";
        sendMail(email, sub, text);
    }
    
    public void checkDuplicateEmail(String email){
        Optional<Account> account = accountRepository.findByEmail(email);
        if(account.isPresent()){
            throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
        }
    }
    
    public void verifyMail(EmailVerifyRequest emailVerifyRequest) {
        String verifyCode = redisService.getData(emailVerifyRequest.getEmail());

        if (verifyCode == null || !verifyCode.equals(emailVerifyRequest.getVerifyCode())){
            throw new BusinessException(ErrorCode.INVALID_VERIFY_CODE);
        }
    }
}
