package lastpunch.authserver.common.exception;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {
    
    @ExceptionHandler({ BusinessException.class })
    public ResponseEntity<Object> handleCustomException(HttpServletRequest request, HttpServletResponse response, BusinessException e){
        log.error("handleBusinessException", e);
        final ResponseEntity<Object> errorResponse = ErrorResponse.toResponseEntity(e.getErrorCode());
        return errorResponse;
    }
    
    @ExceptionHandler({ Exception.class })
    public void handleInternalServerException(HttpServletRequest request, HttpServletResponse response, Exception e) throws IOException {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류입니다.");
        log.error("handleInternalServerException", e);
    }
}