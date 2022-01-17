package lastpunch.gateway.common.exception;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import lastpunch.gateway.filter.AccessTokenFilter;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;


public class AuthExceptionHandler implements ErrorWebExceptionHandler {
    final Logger log = LoggerFactory.getLogger(AccessTokenFilter.class);
    private final Map<String, ErrorCode> exceptionCodeMap;
    
    public AuthExceptionHandler(){
        exceptionCodeMap = new ConcurrentHashMap<>();
        
        exceptionCodeMap.put("java.lang.NullPointerException", ErrorCode.NO_TOKEN);
        exceptionCodeMap.put("io.jsonwebtoken.ExpiredJwtException", ErrorCode.EXPIRED_TOKEN);
        exceptionCodeMap.put("io.jsonwebtoken.MalformedJwtException", ErrorCode.MALFORMED_TOKEN);
        exceptionCodeMap.put("io.jsonwebtoken.security.SignatureException", ErrorCode.MALFORMED_TOKEN);
        exceptionCodeMap.put("io.jsonwebtoken.UnsupportedJwtException", ErrorCode.MALFORMED_TOKEN);
        exceptionCodeMap.put("io.jsonwebtoken.DecodingException", ErrorCode.DECODING_EXCEPTION);
    }
    
    private String errorResponse(ErrorCode errorCode) {
        Map<String, Object> response = new HashMap<String, Object>();
        Map<String, Object> err = new HashMap<String, Object>();
        
        err.put("msg", errorCode.getMsg());
        err.put("desc", errorCode.getDesc());
        
        response.put("code", errorCode.getCode());
        response.put("err", err);
        
        JSONObject json =  new JSONObject(response);
        return json.toString();
    }
    
    @Override
    public Mono<Void> handle(
        ServerWebExchange exchange, Throwable e) {
        log.error("handleGatewayException: " + e.getClass().getName());
        ErrorCode errorCode = exceptionCodeMap.getOrDefault(e.getClass().getName(), ErrorCode.INTERNAL_SERVER_ERROR);

        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(errorCode.getStatus());
        response.getHeaders().add("Content-Type", "application/json");
        byte[] bytes = errorResponse(errorCode).getBytes(StandardCharsets.UTF_8);
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        return response.writeWith(Flux.just(buffer));
    }
}