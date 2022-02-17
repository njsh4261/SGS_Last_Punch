package lastpunch.workspace.repository;

import java.util.Optional;

import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.AccountWorkspace.Dto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

// ManyToOne 필드들로 인해 JPARepository 제공 query나 QueryDSL를 사용하기 어려움
// Native query를 통해 검색
@Repository
public interface AccountWorkspaceRepository extends JpaRepository<AccountWorkspace, Long> {
    // (accountId, workspaceId) tuple은 unique; List가 아닌 Single Item으로 결과를 받음
    @Query(
        value = "SELECT accountId, workspaceId, roleId FROM accountworkspace "
            + "WHERE accountId = :accountId AND workspaceId = :workspaceId",
        nativeQuery = true
    )
    Optional<Dto> get(Long accountId, Long workspaceId);
    
    @Query(
        value = "INSERT INTO accountworkspace (accountid, workspaceid, roleid) "
            + "VALUES (:accountId, :workspaceId, :roleId)",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    void add(Long accountId, Long workspaceId, Long roleId);
    
    @Query(
        value = "UPDATE accountworkspace SET roleid=:roleId "
            + "WHERE accountid=:accountId AND workspaceid=:workspaceId",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    Integer edit(Long accountId, Long workspaceId, Long roleId);
    
    @Query(
        value = "DELETE FROM accountworkspace "
            + "WHERE accountid = :accountId AND workspaceid = :workspaceId",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    Integer delete(Long accountId, Long workspaceId);
}
