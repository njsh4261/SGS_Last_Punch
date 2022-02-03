package lastpunch.gateway;

import lastpunch.gateway.filter.AccessTokenFilter;
import lastpunch.gateway.filter.RefreshTokenFilter;
import lastpunch.gateway.filter.RemoveCorsHeaderFilter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class GatewayApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(GatewayApplication.class, args);
    }
    
    @Bean
    public RouteLocator customRoutes(RouteLocatorBuilder builder, AccessTokenFilter accessTokenFilter, RefreshTokenFilter refreshTokenFilter, RemoveCorsHeaderFilter removeCorsHeaderFilter) {
        return builder.routes()
            .route("auth-verify",  r-> r.path("/auth/verify")
                .filters(f -> f
                    .rewritePath("/auth/(?<segment>.*)", "/${segment}")
                    .filter(accessTokenFilter)
                )
                .uri("lb://AUTH-SERVER"))
            .route("auth-reissue",  r-> r.path("/auth/reissue")
                .filters(f -> f
                    .rewritePath("/auth/(?<segment>.*)", "/${segment}")
                    .filter(refreshTokenFilter)
                )
                .uri("lb://AUTH-SERVER"))
            .route("auth",  r-> r.path("/auth/**")
                .filters(f -> f
                    .rewritePath("/auth/(?<segment>.*)", "/${segment}")
                )
                .uri("lb://AUTH-SERVER"))
            .route("workspace", r -> r.path("/channel/**", "/workspace/**")
                .filters(f -> f
                    .filter(accessTokenFilter)
                )
                .uri("lb://WORKSPACE-SERVER"))
            .route("note-http", r -> r.path("/note/**")
//                .filters(f -> f
//                    .filter(accessTokenFilter)
//                )
                .uri("http://localhost:9000"))
            .route("note-websocket", r -> r.path("ws/note/**")
                .filters(f -> f
                    .filter(removeCorsHeaderFilter)
                )
                .uri("http://localhost:9001"))
            .build();
    }
    
}
