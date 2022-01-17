package lastpunch.gateway.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    
    //Authentication
    NO_TOKEN(HttpStatus.UNAUTHORIZED, "10001", "NO_TOKEN", "토큰이 존재하지 않습니다."),
    EXPIRED_TOKEN(HttpStatus.UNAUTHORIZED, "10002", "EXPIRED_TOKEN", "토큰이 만료되었습니다."),
    MALFORMED_TOKEN(HttpStatus.UNAUTHORIZED, "10003", "MALFORMED_TOKEN", "토큰이 유효하지 않습니다."),
    DECODING_EXCEPTION(HttpStatus.UNAUTHORIZED, "10004", "DECODING_EXCEPTION", "토큰 디코딩 과정에서 에러가 발생했습니다."),
    
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "10999", "INTERNAL_SERVER_ERROR", "게이트웨이에서 에러가 발생했습니다.")
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