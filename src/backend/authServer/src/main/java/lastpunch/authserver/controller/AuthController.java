package lastpunch.authserver.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lastpunch.authserver.common.Response;
import lastpunch.authserver.dto.EmailVerifyRequest;
import lastpunch.authserver.dto.SendEmailRequest;
import lastpunch.authserver.service.AuthService;
import lastpunch.authserver.service.EmailVerifyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.async.DeferredResult;

@RequiredArgsConstructor
@RestController
public class AuthController {
    final private AuthService authService;
    private final EmailVerifyService emailVerifyService;

    @GetMapping("/reissue")
    public ResponseEntity<Object> reissue(@RequestHeader Map<String, Object> requestHeader) {
        String accessToken = authService.reissue(requestHeader);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("access_token", accessToken);

        return Response.toResponseEntity("11000", HttpStatus.OK, data);
    }
    
    @GetMapping("/signout")
    public ResponseEntity<Object> signout(@RequestHeader Map<String, Object> requestHeader) {
        authService.logout(requestHeader);
        return Response.toResponseEntity("11000", HttpStatus.OK);
    }
    
    @PostMapping("/email")
    public ResponseEntity<Object> sendEmail(@RequestBody SendEmailRequest sendEmailRequest) {
        final DeferredResult<List<String>> result = new DeferredResult<>();
        emailVerifyService.sendVerifyMail(sendEmailRequest.getEmail());
        return Response.toResponseEntity("11000", HttpStatus.OK);
    }
    
    @PostMapping("/email-verification")
    public ResponseEntity<Object> emailVerify(@RequestBody EmailVerifyRequest emailVerifyRequest) {
        emailVerifyService.verifyMail(emailVerifyRequest);
        return Response.toResponseEntity("11000", HttpStatus.OK);
    }
    
    @PostMapping("/email-duplicate")
    public ResponseEntity<Object> emailDuplicate(@RequestBody SendEmailRequest sendEmailRequest) {
        emailVerifyService.checkDuplicateEmail(sendEmailRequest.getEmail());
        return Response.toResponseEntity("11000", HttpStatus.OK);
    }
    
    //인증 동작 확인용 API (실사용 X)
    @GetMapping("/verify")
    public ResponseEntity<Object> verify() {
        Map<String, Object> data = new HashMap<String, Object>();
        String msg = "토큰 인증에 성공했습니다.";
        data.put("msg", msg);
        return Response.toResponseEntity("11000", HttpStatus.OK, data);
    }
}
