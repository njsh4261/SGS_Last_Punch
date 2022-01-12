package lastpunch.gateway.common.exception;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.io.DecodingException;
import io.jsonwebtoken.security.SignatureException;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import lastpunch.gateway.filter.AuthFilter;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;


public class AuthExceptionHandler implements ErrorWebExceptionHandler {
    final Logger log = LoggerFactory.getLogger(AuthFilter.class);
    
    private String errorResponse(ErrorCode errorCode) {
        Map<String, Object> response = new HashMap<String, Object>();
        Map<String, Object> err = new HashMap<String, Object>();
        
        Long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);
        
        err.put("msg", errorCode.getMsg());
        err.put("desc", errorCode.getDesc());
        
        response.put("code", errorCode.getCode());
        response.put("status", errorCode.getStatus().value());
        response.put("err", err);
        response.put("timestamp", timestamp);
        
        JSONObject json =  new JSONObject(response);
        return json.toString();
    }
    
    @Override
    public Mono<Void> handle(
        ServerWebExchange exchange, Throwable e) {
        log.error("handleGatewayException: " + e);
        ErrorCode errorCode;
        if (e.getClass() == NullPointerException.class) {
            errorCode = ErrorCode.NO_TOKEN;
        } else if (e.getClass() == ExpiredJwtException.class) {
            errorCode = ErrorCode.EXPIRED_TOKEN;
        } else if (e.getClass() == MalformedJwtException.class || e.getClass() == SignatureException.class || e.getClass() == UnsupportedJwtException.class) {
            errorCode = ErrorCode.MALFORMED_TOKEN;
        } else if (e.getClass() == DecodingException.class) {
            errorCode = ErrorCode.DECODING_EXCEPTION;
        } else{
            errorCode = ErrorCode.INTERNAL_SERVER_ERROR;
        }
        
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(HttpStatus.OK);
        response.getHeaders().add("Content-Type", "application/json");
        byte[] bytes = errorResponse(errorCode).getBytes(StandardCharsets.UTF_8);
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        return response.writeWith(Flux.just(buffer));
    }
}