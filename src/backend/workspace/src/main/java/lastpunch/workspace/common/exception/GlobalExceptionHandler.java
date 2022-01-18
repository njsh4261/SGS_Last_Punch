// original source code work by Jisoo Kim

package lastpunch.workspace.common.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler{
    @ExceptionHandler({ BusinessException.class })
    public ResponseEntity<Object> handleCustomException(
            HttpServletRequest request, HttpServletResponse response, BusinessException e){
        log.error("handleBusinessException", e);
        final ResponseEntity<Object> errorResponse = ErrorResponse.toResponseEntity(e.getStatusCode());
        return errorResponse;
    }
    
    @ExceptionHandler({ Exception.class })
    public void handleInternalServerException(
            HttpServletRequest request, HttpServletResponse response, Exception e) throws IOException {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류입니다.");
        log.error("handleInternalServerException", e);
    }
}