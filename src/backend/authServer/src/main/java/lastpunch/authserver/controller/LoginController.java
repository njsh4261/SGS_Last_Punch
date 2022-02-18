package lastpunch.authserver.controller;

import lastpunch.authserver.common.Response;
import lastpunch.authserver.dto.LoginRequest;
import lastpunch.authserver.dto.LoginResponse;
import lastpunch.authserver.service.LoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RequiredArgsConstructor
@RequestMapping("/login")
@RestController
public class LoginController {
    final private LoginService loginService;
    
    @PostMapping
    public ResponseEntity<Object> login(@RequestBody LoginRequest loginRequest) {
        LoginResponse loginResponse = loginService.login(loginRequest);
        
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("access_token", loginResponse.getAccessToken());
        data.put("refresh_token", loginResponse.getRefreshToken());
        data.put("account", loginResponse.getAccountInfo());

        return Response.toResponseEntity("11000", HttpStatus.OK, data);
    }
}
