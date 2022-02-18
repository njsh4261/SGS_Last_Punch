package lastpunch.authserver.common;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.HashMap;
import java.util.Map;

public class Response {
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status, Object data) {
        Map<String, Object> map = new HashMap<String, Object>();
        
        map.put("code", code);
        map.put("data", data);
        
        return new ResponseEntity<Object>(map,status);
    }
    
    public static ResponseEntity<Object> toResponseEntity(String code, HttpStatus status) {
        Map<String, Object> map = new HashMap<String, Object>();
        
        map.put("code", code);
        
        return new ResponseEntity<Object>(map,status);
    }
    
}
