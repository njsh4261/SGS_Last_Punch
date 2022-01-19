package lastpunch.notehttpserver.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    
    //http
    NOTE_NOT_EXIST(HttpStatus.OK, "11001", "NOTE_NOT_EXIST", "존재하지 않는 노트입니다."),
    
 
    ;
    
    private HttpStatus status;
    private final String code;
    private final String msg;
    private final String desc;
    
    ErrorCode(final HttpStatus status, final String code, final String msg, final String desc) {
        this.status = status;
        this.msg = msg;
        this.code = code;
        this.desc = desc;
    }
}
