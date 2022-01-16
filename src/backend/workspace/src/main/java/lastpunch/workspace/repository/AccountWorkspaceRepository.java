package lastpunch.workspace.repository;

import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface AccountWorkspaceRepository extends JpaRepository<AccountWorkspace, Long>{
    @Query(
        value = "INSERT INTO accountworkspace (accountid, workspaceid) "
            + "VALUES (:accountId, :workspaceId)",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    void save(Long accountId, Long workspaceId);
    
    @Query(
        value = "DELETE FROM accountworkspace "
            + "WHERE accountid = :accountId AND workspaceid = :workspaceId",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    void delete(Long accountId, Long workspaceId);
}
