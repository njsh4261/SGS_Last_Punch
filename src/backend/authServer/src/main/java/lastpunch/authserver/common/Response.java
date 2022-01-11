package lastpunch.authserver.common;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

public class Response {
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status, Object data) {
        Map<String, Object> map = new HashMap<String, Object>();
        Long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);
        
        map.put("status", status.value());
        map.put("code", code);
        map.put("data", data);
        map.put("timestamp", timestamp);
        
        return new ResponseEntity<Object>(map,status);
    }
    
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status) {
        Map<String, Object> map = new HashMap<String, Object>();
        Long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);
        
        map.put("status", status.value());
        map.put("code", code);
        map.put("timestamp", timestamp);
        
        return new ResponseEntity<Object>(map,status);
    }
    
}
