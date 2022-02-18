package lastpunch.presence.common;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum UserStatus{
    // 세션 연결
    CONNECT,        // 세션이 연결 및 재연결된 상황을 명시 (ONLINE과 구분)
    
    // 세션 연결 중 사용자 상태 변경
    ONLINE,         // 사용자가 본인의 상태를 '온라인'으로 표시
    ABSENT,         // 사용자가 본인의 상태를 '부재 중'으로 표시
    BUSY,           // 사용자가 본인의 상태를 '다른 용무 중'으로 표시
    OFFLINE,        // 사용자가 본인의 상태를 '오프라인'으로 표시
    
    // 세션 종료
    DISCONNECT,     // 세션이 종료된 상황을 명시 (OFFLINE과 구분)
    
    // 비정상 상태
    UNKNOWN;        // 사용자 상태가 메시지에 정상적으로 명시되지 않은 경우
    
    @JsonCreator
    public static UserStatus toEnum(String s){
        try{
            return UserStatus.valueOf(s);
        } catch(IllegalArgumentException e){
            return UserStatus.UNKNOWN;
        }
    }
}
