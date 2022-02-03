package lastpunch.gateway.filter;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
public class RemoveCorsHeaderFilter implements GatewayFilter, Ordered {
    String origin = "http://localhost:3000";
    
    @Override
    public int getOrder() {
        return 1;
    }
    
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        
        return chain.filter(exchange)
            // proxied service 에서 response를 받은 이후 실행
            .then(Mono.fromRunnable(() -> {
                    ServerHttpResponse response = exchange.getResponse();
                    response.getHeaders().set("Access-Control-Allow-Origin", origin);
                    response.getHeaders().set("Access-Control-Allow-Credentials", "true");
            }));
        }
    
    public static class Config {
    
    }
}
