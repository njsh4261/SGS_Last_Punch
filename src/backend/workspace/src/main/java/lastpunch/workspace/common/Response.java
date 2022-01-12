// original source code work by Jisoo Kim

package lastpunch.workspace.common;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

public class Response {
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status, Object data) {
        Map<String, Object> map = new HashMap<>();
        long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);
        
        map.put("status", status.value());
        map.put("code", code);
        map.put("data", data);
        map.put("timestamp", timestamp);
        
        return new ResponseEntity<>(map, status);
    }
    
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status) {
        Map<String, Object> map = new HashMap<>();
        long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);

        map.put("status", status.value());
        map.put("code", code);
        map.put("timestamp", timestamp);

        return new ResponseEntity<>(map, status);
    }

    public static ResponseEntity<Object> ok(ServerCode serverCode){
        return toResponseEntity(serverCode.getOkServerCode(), serverCode.getOkHttpStatus());
    }

    public static ResponseEntity<Object> ok(ServerCode serverCode, Object data){
        return toResponseEntity(serverCode.getOkServerCode(), serverCode.getOkHttpStatus(), data);
    }
}
