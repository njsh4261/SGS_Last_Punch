package lastpunch.chat.common.exception;

import lombok.Getter;

@Getter
public class BusinessException extends RuntimeException{
    private StatusCode statusCode;
    
    public BusinessException(StatusCode statusCode) {
        this.statusCode = statusCode;
    }
}