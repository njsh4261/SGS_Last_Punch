package lastpunch.workspace.repository.workspace;

import static lastpunch.workspace.entity.QWorkspace.workspace;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.entity.Workspace.ExportDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class WorkspaceRepositoryImpl implements WorkspaceRepositoryCustom{
    private JPAQueryFactory jpaQueryFactory;
    
    @Override
    public ExportDto getOneWorkspace(Long id){
        return jpaQueryFactory.select(
                Projections.constructor(Workspace.ExportDto.class,
                    workspace.id, workspace.name, workspace.description, workspace.settings,
                    workspace.status, workspace.createdt, workspace.modifydt
                )
            )
            .from(workspace)
            .where(workspace.id.eq(id))
            .fetchOne();
    }
}
