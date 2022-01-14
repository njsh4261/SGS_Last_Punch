package lastpunch.gateway;

import lastpunch.gateway.filter.AuthFilter;
import org.springframework.beans.factory.annotation.Value;
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
    public RouteLocator customRoutes(RouteLocatorBuilder builder, AuthFilter authFilter) {
        return builder.routes()
            .route("auth-verify",  r-> r.path("/auth/login/verify")
                .filters(f -> f
                    .rewritePath("/auth/(?<segment>.*)", "/${segment}")
                    .filter(authFilter)
                )
                .uri("lb://AUTH-SERVER"))
            .route("auth",  r-> r.path("/auth/**")
                .filters(f -> f
                    .rewritePath("/auth/(?<segment>.*)", "/${segment}")
                )
                .uri("lb://AUTH-SERVER"))
            .build();
    }
    
}
