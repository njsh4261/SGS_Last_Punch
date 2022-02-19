package lastpunch.authserver.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    //Signup
    DUPLICATE_EMAIL(HttpStatus.OK, "11001", "DUPLICATE_EMAIL", "이미 가입된 이메일입니다."),
    
    //Login
    BAD_CREDENTIALS(HttpStatus.OK, "11002", "BAD_CREDENTIALS", "이메일 혹은 패스워드를 잘못 입력했습니다."),
    
    //Email Verification
    INVALID_VERIFY_CODE(HttpStatus.OK, "11003", "INVALID_VERIFY_CODE", "이메일 인증 코드가 유효하지 않습니다."),
    MODIFIED_EMAIL_VERIFY_DATA(HttpStatus.OK, "11004", "MODIFIED_EMAIL_VERIFY_DATA", "이메일 인증 시 사용했던 데이터가 변조되었습니다."),
    MAIL_SEND_ERROR(HttpStatus.OK, "11005", "MAIL_SEND_ERROR", "인증 이메일 전송에 문제가 발생했습니다."),
    
    INVALID_REFRESH_TOKEN(HttpStatus.OK, "11006", "INVALID_REFRESH_TOKEN", "유효하지 않은 refresh token 입니다."),
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
