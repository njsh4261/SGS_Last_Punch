package lastpunch.notehttpserver.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    
    //http
    NOTE_NOT_EXIST(HttpStatus.OK, "15001", "NOTE_NOT_EXIST", "존재하지 않는 노트입니다."),
    OPERATION_NOT_EXIST(HttpStatus.OK, "15002", "OPERATION_NOT_EXIST", "존재하지 않는 operation입니다."),
    JSON_DATA_ERROR(HttpStatus.OK, "15003", "JSON_DATA_ERROR", "request body의 데이터 형식이 잘못되었습니다."),
    
 
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
