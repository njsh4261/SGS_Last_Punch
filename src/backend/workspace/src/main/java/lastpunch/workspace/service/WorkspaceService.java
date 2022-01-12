package lastpunch.workspace.service;

import java.util.Optional;

import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
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
    
    public Page<Workspace> getList(Long userId, Pageable pageable) {
        // TODO: 각 워크스페이스마다 5명 정도 해당 워크스페이스의 참가자 목록을 보여줘야 함
        return workspaceRepository.findAllById(userId, pageable);
    }
    
    public Workspace getOne(Long workspaceId) {
        // TODO: 워크스페이스 하나의 정보를 불러올 때, 해당 워크스페이스의 소속 멤버 목록과 채널 목록도 함께 불러와야 함
        Optional<Workspace> workspace = workspaceRepository.findById(workspaceId);
        if(workspace.isPresent()) {
            return workspace.get();
        } else {
            throw new BusinessException(StatusCode.WORKSPACE_NOT_EXIST);
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
        // 추후에 아카이빙 기능(삭제한 데이터를 별도의 DB에 백업)을 구현한다면,
        // status field를 "deleted" 등으로 수정하여 live server와 다른 DB 서버에 저장하는 기능 추가
        workspaceRepository.deleteById(id);
    }
}
