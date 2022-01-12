package lastpunch.authserver.common.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    
    //Signup
    DUPLICATE_EMAIL(HttpStatus.OK, "11001", "DUPLICATE_EMAIL", "이미 가입된 이메일입니다."),
    
    //Login
    BAD_CREDENTIALS(HttpStatus.OK, "11002", "BAD_CREDENTIALS", "이메일 혹은 패스워드를 잘못 입력했습니다.")
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
