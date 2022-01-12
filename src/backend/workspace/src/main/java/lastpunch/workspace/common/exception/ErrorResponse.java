// original source code work by Jisoo Kim

package lastpunch.workspace.common.exception;

import lastpunch.workspace.common.StatusCode;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.HashMap;
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
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> err = new HashMap<>();
        
        long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);
        
        err.put("msg", statusCode.getMsg());
        err.put("desc", statusCode.getDesc());
        
        response.put("code", statusCode.getCode());
        response.put("status", statusCode.getStatus().value());
        response.put("err", err);
        response.put("timestamp", timestamp);
        
        return new ResponseEntity<>(response, statusCode.getStatus());
    }
}
