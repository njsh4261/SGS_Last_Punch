package lastpunch.workspace.common.type;

import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import lastpunch.workspace.entity.Role;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum RoleType{
    NORMAL_USER(1L), ADMIN(2L), OWNER(3L);
    private final Long id;
    
    private static final Map<Long, RoleType> map = new ConcurrentHashMap<>();
    static {
        for(RoleType roleType: RoleType.values()){
            map.put(roleType.getId(), roleType);
        }
    }
    
    public static RoleType toEnum(Long id){
        return map.getOrDefault(id, RoleType.NORMAL_USER);
    }
    
    public boolean hasPermission(){
        return this.id >= RoleType.ADMIN.getId();
    }
    
    public boolean isOwner(){
        return Objects.equals(this.id, RoleType.OWNER.getId());
    }
}
