package lastpunch.notehttpserver.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

@Slf4j
@Component
public class RequestInterceptor extends HandlerInterceptorAdapter {
    // 개발 디버깅용으로만 사용. 추후 삭제
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        log.info(request.getMethod() + " " + request.getRequestURI());
        return super.preHandle(request, response, handler);
    }
}
