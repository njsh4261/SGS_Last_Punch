// original source code work by Jisoo Kim

package lastpunch.workspace.common.exception;

import lastpunch.workspace.common.StatusCode;
import lombok.Getter;

@Getter
public class BusinessException extends RuntimeException{
    private StatusCode statusCode;
    
    public BusinessException(StatusCode statusCode) {
        this.statusCode = statusCode;
    }
}