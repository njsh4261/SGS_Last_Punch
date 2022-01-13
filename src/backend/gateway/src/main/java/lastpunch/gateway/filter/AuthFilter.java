package lastpunch.gateway.filter;

import static org.springframework.cloud.gateway.support.ServerWebExchangeUtils.GATEWAY_REQUEST_URL_ATTR;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import lastpunch.gateway.common.exception.AuthExceptionHandler;
import lastpunch.gateway.common.exception.ErrorCode;
import lastpunch.gateway.common.jwt.JwtProvider;
import lastpunch.gateway.filter.AuthFilter.Config;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.core.Ordered;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Component
public class AuthFilter implements GatewayFilter, Ordered{
    @Autowired
    private JwtProvider jwtProvider;
    
    @Override
    public int getOrder() {
        return 10001;
    }
    
    @Bean
    public ErrorWebExceptionHandler myExceptionHandler() {
        return new AuthExceptionHandler();
    }
  
    @Override
    public Mono<Void> filter(
        ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String accessToken, refreshToken;
        
        // 인증 통과: 1) accessToken만 유효 2) refreshToken만 유효 3) 둘 다 유효
        
        // 1. accessToken, refreshToken 둘 다 존재하는지 확인
        accessToken = request.getHeaders().get("accessToken").get(0);
        refreshToken = request.getHeaders().get("refreshToken").get(0);
    
        // 2. accessToken이 유효한 경우 -> 요청 진행
        try {
            if(jwtProvider.validateToken(accessToken)) {
                return chain.filter(exchange);
            }
        }
        catch(Exception e){
        }
        // 3. accessToken이 유효하지 않고, refresh 유효한 경우 -> 새 accessToken 발행 (인증서버로 요청)
        if (jwtProvider.validateToken(refreshToken)){
            URI uri = UriComponentsBuilder.fromUriString("http://localhost:8081/login/reissue").build().toUri();
            exchange.getAttributes().put(GATEWAY_REQUEST_URL_ATTR, uri);
            return chain.filter(exchange);
        }
        throw new MalformedJwtException("Invalid Access Token");
    }
    
    public static class Config {
    
    }
}