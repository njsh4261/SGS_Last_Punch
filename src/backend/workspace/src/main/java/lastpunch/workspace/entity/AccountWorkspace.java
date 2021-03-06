package lastpunch.workspace.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name="accountworkspace")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountWorkspace{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(targetEntity= Account.class, fetch=FetchType.LAZY)
    @JoinColumn(name="accountid")
    private Account account;

    @ManyToOne(targetEntity=Workspace.class, fetch = FetchType.LAZY)
    @JoinColumn(name="workspaceid")
    private Workspace workspace;
    
    @ManyToOne(targetEntity = Role.class, fetch = FetchType.LAZY)
    @JoinColumn(name="roleid")
    private Role role;
    
    public interface Dto{
        Long getAccountId();
        Long getWorkspaceId();
        Long getRoleId();
    }
    
    @Getter
    @Builder
    public static class DtoImpl implements Dto{
        private Long accountId;
        private Long workspaceId;
        private Long roleId;
    }
}
