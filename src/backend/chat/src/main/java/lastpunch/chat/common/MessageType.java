package lastpunch.chat.common;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum MessageType{
    MESSAGE, TYPING;
    
    @JsonCreator
    public static MessageType toEnum(String s){
        try{
            return MessageType.valueOf(s);
        } catch(IllegalArgumentException e){
            return MessageType.MESSAGE;
        }
    }
}
