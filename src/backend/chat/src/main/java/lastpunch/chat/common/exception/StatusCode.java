package lastpunch.chat.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum StatusCode{
    
    //http
    CHAT_OK(HttpStatus.OK, "13000", "CHAT_OK", "채팅 API 성공"),
    TOKEN_NOT_EXIST(HttpStatus.UNAUTHORIZED, "13001", "TOKEN_NOT_EXIST", "토큰이 존재하지 않습니다."),
    TOKEN_INVALID(HttpStatus.UNAUTHORIZED, "13001", "TOKEN_INVALID", "토큰이 유효하지 않습니다.");
    
    private HttpStatus status;
    private final String code;
    private final String msg;
    private final String desc;
    
    StatusCode(final HttpStatus status, final String code, final String msg, final String desc) {
        this.status = status;
        this.msg = msg;
        this.code = code;
        this.desc = desc;
    }
}
