package lastpunch.workspace.repository;

import java.util.Optional;
import lastpunch.workspace.entity.Workspace;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WorkspaceRepository extends JpaRepository<Workspace, Long>{
    Page<Workspace> findAllById(Long id, Pageable pageable);
}
