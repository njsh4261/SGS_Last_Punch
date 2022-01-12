package lastpunch.workspace.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name="member_workspace")
@Getter
@Setter
@Builder
@AllArgsConstructor
public class MemberWorkspace {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(targetEntity=Member.class, fetch=FetchType.LAZY)
    @JoinColumn(name="id")
    private Long memberId;

    @ManyToOne(targetEntity=Workspace.class, fetch = FetchType.LAZY)
    @JoinColumn(name="id")
    private Long workspaceId;
}
