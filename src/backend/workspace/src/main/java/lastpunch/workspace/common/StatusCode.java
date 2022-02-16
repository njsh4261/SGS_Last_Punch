// original source code work by Jisoo Kim

package lastpunch.workspace.common;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum StatusCode{
    WORKSPACE_OK(HttpStatus.OK, "12000", "WORKSPACE_OK", "워크스페이스 API 성공"),
    WORKSPACE_NOT_EXIST(HttpStatus.OK, "12001", "WORKSPACE_NOT_EXIST", "존재하지 않는 워크스페이스입니다."),
    ACCOUNT_NOT_EXIST(HttpStatus.OK, "12002", "ACCOUNT_NOT_EXIST", "존재하지 않는 사용자입니다."),
    CHANNEL_NOT_EXIST(HttpStatus.OK, "12003", "CHANNEL_NOT_EXIST", "존재하지 않는 채널입니다."),
    ACCOUNTWORKSPACE_NOT_EXIST(HttpStatus.OK, "12004", "ACCOUNTWORKSPACE_NOT_EXIST", "존재하지 않는 유저와 워크스페이스 간 관계입니다."),
    ACCOUNTWORKSPACE_ALREADY_EXIST(HttpStatus.OK, "12005", "ACCOUNTWORKSPACE_ALREADY_EXIST", "유저와 워크스페이스 간 관계가 이미 존재합니다."),
    ACCOUNTCHANNEL_NOT_EXIST(HttpStatus.OK, "12006", "ACCOUNTCHANNEL_NOT_EXIST", "존재하지 않는 유저와 채널 간 관계입니다."),
    ACCOUNTCHANNEL_ALREADY_EXIST(HttpStatus.OK, "12007", "ACCOUNTCHANNEL_ALREADY_EXIST", "유저와 채널 간 관계가 이미 존재합니다."),
    INVALID_USERID(HttpStatus.OK, "12008", "INVALID_USERID", "사용자 ID가 정상적으로 제공되지 않았습니다."),
    PERMISSION_DENIED(HttpStatus.OK, "12009", "PERMISSION_DENIED", "해당 작업을 실행할 권한이 없습니다."),
    ROLE_NOT_EXIST(HttpStatus.OK, "12010", "ROLE_NOT_EXIST", "존재하지 않는 역할입니다."),
    CHANNEL_ALREADY_EXIST(HttpStatus.OK, "12011", "CHANNEL_ALREADY_EXIST", "이미 존재하는 채널입니다."),
    CHANNEL_OWNER_SET_ERROR(HttpStatus.OK, "12012", " CHANNEL_OWNER_SET_ERROR", "채널의 소유자가 정상적으로 지정되지 않았습니다."),
    INVALID_PARAMETERS(HttpStatus.OK, "12013", "INVALID_PARAMETERS", "요청에 필요한 항목이 정상적으로 제공되지 않았습니다."),
    WORKSPACE_OWNER_SET_ERROR(HttpStatus.OK, "12012", " WORKSPACE_OWNER_SET_ERROR", "워크스페이스의 소유자가 정상적으로 지정되지 않았습니다.");
    
    private final HttpStatus status;
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
