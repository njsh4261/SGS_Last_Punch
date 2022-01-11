package lastpunch.authserver.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class loginController {
    @GetMapping("/")
    public String info(@Value("${server.port}") String port) {
        return "Auth 서비스의 기본 동작 Port: {" + port + "}";
    }
}
