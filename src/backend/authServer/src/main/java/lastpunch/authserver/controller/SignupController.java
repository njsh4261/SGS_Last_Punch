package lastpunch.authserver.controller;

import lastpunch.authserver.dto.SignupRequest;
import lastpunch.authserver.service.EmailVerifyService;
import lastpunch.authserver.service.SignupService;
import lastpunch.authserver.common.Response;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/signup")
@RestController
public class SignupController {
    private final SignupService signupService;
    private final EmailVerifyService emailVerifyService;

    @PostMapping
    public ResponseEntity<Object> signup(@RequestBody SignupRequest signupRequest) {
        signupService.signup(signupRequest);
        return Response.toResponseEntity("11000", HttpStatus.OK);
    }
}
