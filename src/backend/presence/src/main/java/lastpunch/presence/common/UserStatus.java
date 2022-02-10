package lastpunch.presence.common;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum UserStatus{
    ONLINE, ABSENT, BUSY, OFFLINE, DISCONNECT, UNKNOWN;
    
    @JsonCreator
    public static UserStatus toEnum(String s){
        try{
            return UserStatus.valueOf(s);
        } catch(IllegalArgumentException e){
            return UserStatus.UNKNOWN;
        }
    }
}
