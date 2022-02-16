// original source code work by Jisoo Kim

package lastpunch.workspace.common;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

public class Response {
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status, Object data) {
        return new ResponseEntity<>(Map.of("code", code,"data", data), status);
    }
    
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status) {
        return new ResponseEntity<>(Map.of("code", code), status);
    }

    public static ResponseEntity<Object> ok(Object data){
        return toResponseEntity(
            StatusCode.WORKSPACE_OK.getCode(),
            StatusCode.WORKSPACE_OK.getStatus(),
            data
        );
    }
}
