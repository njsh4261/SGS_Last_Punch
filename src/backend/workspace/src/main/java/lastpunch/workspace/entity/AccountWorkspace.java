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
    
    @Getter
    @Builder
    public static class Dto {
        private Long accountId;
        private Long workspaceId;
    }
}
