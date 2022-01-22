package lastpunch.gateway.filter;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import lastpunch.gateway.common.exception.AuthExceptionHandler;
import lastpunch.gateway.common.jwt.JwtProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
public class AccessTokenFilter implements GatewayFilter, Ordered{
    @Autowired
    private JwtProvider jwtProvider;
    
    private final Logger logger = LoggerFactory.getLogger(AccessTokenFilter.class);
    
    @Override
    public int getOrder() {
        return -1;
    }
  
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();

        // 1. accessToken이 존재하는지 확인
        String accessToken = request.getHeaders().get("X-AUTH-TOKEN").get(0);
        if(accessToken == "")
            throw new NullPointerException();

        // 2. accessToken이 유효한 경우 -> 요청 진행, 유효하지 않은 경우 exception handler에 에러 걸려서 401 리턴
        jwtProvider.validateToken(accessToken);

        // 토큰에서 userId 정보를 받아 request header에 담음
        request.mutate().header("userId", jwtProvider.getUserId()).build();
//        logger.info("request.getHeaders().toString() = " + request.getHeaders().toString());
        return chain.filter(exchange);
    }
    
    public static class Config {
    
    }
}