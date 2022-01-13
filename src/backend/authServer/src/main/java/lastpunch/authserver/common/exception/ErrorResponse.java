package lastpunch.authserver.common.exception;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ErrorResponse {
    private String code;
    private HttpStatus status;
    private String msg;
    private String desc;
    
    private ErrorResponse(final ErrorCode errorCode) {
        this.code = errorCode.getCode();
        this.status = errorCode.getStatus();
        this.msg = errorCode.getMsg();
        this.desc = errorCode.getDesc();
    }
    
    public static ResponseEntity<Object> toResponseEntity(final ErrorCode errorCode) {
        Map<String, Object> response = new HashMap<String, Object>();
        Map<String, Object> err = new HashMap<String, Object>();
        
        Long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);
        
        err.put("msg", errorCode.getMsg());
        err.put("desc", errorCode.getDesc());
        
        response.put("code", errorCode.getCode());
        response.put("err", err);
        
        return new ResponseEntity<Object>(response,errorCode.getStatus());
    }
}
