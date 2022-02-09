package lastpunch.presence.common;

import java.util.HashMap;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UserStatus{
    ONLINE("온라인"),
    ABSENT("부재 중"),
    BUSY("다른 용무 중"),
    OFFLINE("오프라인"),
    UNKNOWN("알 수 없음");
    
    private final String status;
    
    @Override
    public String toString(){
        return status;
    }
    
    private static final Map<String, UserStatus> map = new HashMap<>();
    static {
        for(UserStatus status: UserStatus.values()){
            map.put(status.getStatus(), status);
        }
    }
    
    public static UserStatus findUserStatus(String key){
        return map.getOrDefault(key, UserStatus.UNKNOWN);
    }
}
