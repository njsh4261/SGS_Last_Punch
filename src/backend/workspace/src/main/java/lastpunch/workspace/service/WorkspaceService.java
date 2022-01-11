package lastpunch.workspace.service;

import java.util.Optional;
import lastpunch.workspace.dto.WorkspaceDto;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.WorkspaceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class WorkspaceService{
    private WorkspaceRepository workspaceRepository;
    
    @Autowired
    public WorkspaceService(WorkspaceRepository workspaceRepository) {
        this.workspaceRepository = workspaceRepository;
    }
    
    public Page<Workspace> getList(Pageable pageable) {
        return workspaceRepository.findAll(pageable);
    }
    
    public Workspace getOne(Long id) {
        Optional<Workspace> workspace = workspaceRepository.findById(id);
        if(workspace.isPresent()) {
            return workspace.get();
        }
    }
    
    public Workspace createOne(WorkspaceDto workspaceDto) {
        return workspaceRepository.save(workspaceDto.toEntity());
    }
    
    public Workspace editOne(WorkspaceDto workspaceDto, Long id) {
        Workspace workspace = workspaceDto.toEntity();
        workspace.setId(id);
        return workspaceRepository.save(workspace);
    }
    
    public void deleteOne(Long id) {
        workspaceRepository.deleteById(id);
    }
}
