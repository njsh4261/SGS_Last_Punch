package lastpunch.authserver.controller;

import java.util.HashMap;
import java.util.Map;
import lastpunch.authserver.common.Response;
import lastpunch.authserver.dto.LoginRequest;
import lastpunch.authserver.dto.Tokens;
import lastpunch.authserver.service.LoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/login")
@RestController
public class LoginController {
    final private LoginService loginService;
    
    @PostMapping
    public ResponseEntity<Object> postLogin(@RequestBody LoginRequest loginRequest) {
        Tokens tokens = loginService.login(loginRequest);
        
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("access_token", tokens.getAccessToken());
        data.put("refresh_token", tokens.getRefreshToken());

        return Response.toResponseEntity("11000", HttpStatus.OK, data);
    }
}
