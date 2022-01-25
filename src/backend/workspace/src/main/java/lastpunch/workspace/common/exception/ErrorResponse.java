// original source code work by Jisoo Kim

package lastpunch.workspace.common.exception;

import lastpunch.workspace.common.StatusCode;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ErrorResponse{
    private String code;
    private HttpStatus status;
    private String msg;
    private String desc;
    
    private ErrorResponse(final StatusCode statusCode){
        this.code = statusCode.getCode();
        this.status = statusCode.getStatus();
        this.msg = statusCode.getMsg();
        this.desc = statusCode.getDesc();
    }
    
    public static ResponseEntity<Object> toResponseEntity(final StatusCode statusCode){
        return new ResponseEntity<>(
            Map.of(
                "code", statusCode.getCode(),
                "err", Map.of("msg", statusCode.getMsg(),"desc", statusCode.getDesc())
            ),
            statusCode.getStatus()
        );
    }
}
