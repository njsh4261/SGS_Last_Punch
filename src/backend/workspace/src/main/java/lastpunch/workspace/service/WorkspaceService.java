package lastpunch.workspace.service;

import java.util.List;
import java.util.Map;

import java.util.stream.Collectors;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.workspace.WorkspaceRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class WorkspaceService{
    private final CommonService commonService;
    private final WorkspaceRepository workspaceRepository;
    
    public WorkspaceService(CommonService commonService, WorkspaceRepository workspaceRepository){
        this.commonService = commonService;
        this.workspaceRepository = workspaceRepository;
    }
    
    public Map<String, Object> getList(Long id, Pageable pageable){
        return Map.of("workspaces", workspaceRepository.getListWithUserId(id, pageable));
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of("workspace", commonService.getWorkspace(id).export());
    }

    public Map<String, Object> getMembers(Long id, Pageable pageable){
        return Map.of("members", workspaceRepository.getMembers(id, pageable));
    }

    public Map<String, Object> getChannels(Long id, Pageable pageable){
        return Map.of("channels", workspaceRepository.getChannels(id, pageable));
    }

    public void create(Workspace.ImportDto workspaceDto){
        workspaceRepository.save(workspaceDto.toEntity());
    }
    
    public void edit(Workspace.ImportDto workspaceDto, Long id){
        workspaceRepository.save(workspaceDto.changeValues(commonService.getWorkspace(id)));
    }
    
    public void delete(Long id){
        workspaceRepository.deleteById(id);
    }
}
