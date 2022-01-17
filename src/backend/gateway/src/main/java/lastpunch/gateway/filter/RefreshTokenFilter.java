package lastpunch.gateway.filter;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import lastpunch.gateway.common.exception.AuthExceptionHandler;
import lastpunch.gateway.common.jwt.JwtProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.context.annotation.Bean;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
// Check if access token is valid
public class RefreshTokenFilter implements GatewayFilter, Ordered{
    @Autowired
    private JwtProvider jwtProvider;
    
    @Override
    public int getOrder() {
        return 10002;
    }
    
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        
        // 1. refreshToken이 존재하는지 확인
        String refreshToken = request.getHeaders().get("X-AUTH-TOKEN").get(0);
        if (refreshToken == "") throw new NullPointerException();
        
        // 2. refreshToken이 유효한 경우 -> accessToken 재발급 요청 진행, 유효하지 않은 경우 exception handler에 에러 걸려서 401 리턴
        jwtProvider.validateToken(refreshToken);
        return chain.filter(exchange);
    }
    
    public static class Config {
    
    }
}