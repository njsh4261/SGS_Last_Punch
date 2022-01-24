package lastpunch.notewebsocketserver;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public class User {
    
    private String alias;
    private String avatar;
    
    public static User systemUser(){
        return new User("System");
    }
    @JsonCreator
    public User(@JsonProperty("alias") String alias) {
        this.alias = alias;
    }
    
    public String getAlias() {
        return alias;
    }
    
    
}
