package lastpunch.authserver.controller;

import java.util.HashMap;
import java.util.Map;
import lastpunch.authserver.common.Response;
import lastpunch.authserver.service.LoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class AuthController {
    final private LoginService loginService;

    @GetMapping("/reissue")
    public ResponseEntity<Object> postReissue(@RequestHeader Map<String, Object> requestHeader) {
        String accessToken = loginService.reissue(requestHeader);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("access_token", accessToken);
        
        return Response.toResponseEntity("11000", HttpStatus.OK, data);
    }
    
    @GetMapping("/verify")
    public ResponseEntity<Object> verify() {
        Map<String, Object> data = new HashMap<String, Object>();
        String msg = "인증에 성공했습니다.";
        data.put("msg", msg);
        
        return Response.toResponseEntity("11000", HttpStatus.OK, data);
    }
}
