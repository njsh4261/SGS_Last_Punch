package com.example.notemvcwebsocketserver.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    
    //http
    MESSAGE_SEND_FAIL(HttpStatus.OK, "15500", "MESSAGE_SEND_FAIL", "subscriber에게 메세지 전달을 실패했습니다."),
    JSON_PROCESSING_FAIL(HttpStatus.OK, "15501", "JSON_PROCESSING_FAIL", "Json 데이터를 처리하는데 실패했습니다."),
    REDIS_FLUSHALL_FAIL(HttpStatus.OK, "15550", "REDIS_FLUSHALL_FAIL", ""),
    
 
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
