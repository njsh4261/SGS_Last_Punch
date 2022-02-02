package lastpunch.notehttpserver.config;

import lastpunch.notehttpserver.common.RequestInterceptor;
import lombok.RequiredArgsConstructor;
import org.aopalliance.intercept.Interceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@RequiredArgsConstructor
@Configuration
public class WebConfig implements WebMvcConfigurer {
    private final RequestInterceptor requestInterceptor;
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(requestInterceptor)
            .addPathPatterns("/**");
    }
    
    // 임시 CORS 설정 (gateway 연결 후 삭제)
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("http://localhost:3000")
            .allowedHeaders("*")
            .allowedMethods("*");
    }
}