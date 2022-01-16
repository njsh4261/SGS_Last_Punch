package lastpunch.workspace.repository;

import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountWorkspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {
//    void deleteByWorkspaceIdAndMemberId(Long workspaceId, Long memberId);
}
