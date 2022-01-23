package lastpunch.workspace.common.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum RoleType{
    NORMAL_USER(1L), ADMIN(2L), OWNER(3L);
    private Long id;
}
