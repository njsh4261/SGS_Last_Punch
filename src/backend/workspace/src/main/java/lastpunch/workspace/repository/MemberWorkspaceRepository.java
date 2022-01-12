package lastpunch.workspace.repository;

import lastpunch.workspace.entity.MemberWorkspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberWorkspaceRepository extends JpaRepository<MemberWorkspace, Long> {
    MemberWorkspace save(MemberWorkspace memberWorkspace);
    void deleteByWorkspaceIdAndMemberId(Long workspaceId, Long memberId);
}
