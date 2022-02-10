package lastpunch.presence.common;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum UserStatus{
    ONLINE, ABSENT, BUSY, OFFLINE, UNKNOWN;
    
    @JsonCreator
    public static UserStatus toEnum(String s){
        try{
            return UserStatus.valueOf(s);
        } catch(IllegalArgumentException e){
            return UserStatus.UNKNOWN;
        }
    }
}
