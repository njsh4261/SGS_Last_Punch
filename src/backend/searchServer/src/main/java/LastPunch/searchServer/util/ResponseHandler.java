package LastPunch.searchServer.util;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

public class ResponseHandler {
    public static ResponseEntity<Object> generate(String code, HttpStatus status, Object data) {
        Map<String, Object> map = new HashMap<String, Object>();
        Long datetime = System.currentTimeMillis();
        Timestamp timestamp = new Timestamp(datetime);

        map.put("status", status.value());
        map.put("code", code);
        map.put("data", data);
        map.put("timestamp", timestamp);

        return new ResponseEntity<Object>(map,status);
    }
}