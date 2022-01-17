package lastpunch.workspace.repository.workspace;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import lastpunch.workspace.entity.Workspace;

@Repository
public interface WorkspaceRepository extends JpaRepository<Workspace, Long>, WorkspaceRepositoryCustom{
    Page<Workspace> findAllById(Long id, Pageable pageable);
}
