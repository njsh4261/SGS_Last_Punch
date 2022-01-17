package lastpunch.gateway.config;

import lastpunch.gateway.common.exception.AuthExceptionHandler;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ExceptionConfig {
    @Bean
    public ErrorWebExceptionHandler ExceptionHandler() {
        return new AuthExceptionHandler();
    }
}
