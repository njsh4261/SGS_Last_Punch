package lastpunch.authserver.common.exception;

import lombok.Getter;

@Getter
public class BusinessException extends RuntimeException{
    private ErrorCode errorCode;
    
    public BusinessException(ErrorCode errorCode) {
        this.errorCode = errorCode;
    }
    
}