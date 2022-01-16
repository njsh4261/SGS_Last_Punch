package lastpunch.workspace.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.dto.WorkspaceDto;
import lastpunch.workspace.dto.WorkspaceExportDto;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.repository.AccountRepository;
import lastpunch.workspace.repository.WorkspaceRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class WorkspaceService{
    private final WorkspaceRepository workspaceRepository;
    private final AccountRepository accountRepository;
    
    public WorkspaceService(
            WorkspaceRepository workspaceRepository, AccountRepository accountRepository){
        this.workspaceRepository = workspaceRepository;
        this.accountRepository = accountRepository;
    }
    
    public List<WorkspaceExportDto> getList(Long userId, Pageable pageable) {
        Optional<Account> accountOptional = accountRepository.findById(userId);
        if(accountOptional.isEmpty()){
            throw new BusinessException(StatusCode.WORKSPACE_AC_NOT_EXIST);
        }
        List<AccountWorkspace> list = accountOptional.get().getWorkspaces();
        int start = (int) pageable.getOffset();
        return list.subList(start, Math.min(list.size(), start + pageable.getPageSize()))
            .stream().map(AccountWorkspace::getWorkspace).map(Workspace::export)
            .collect(Collectors.toList());
    }
    
    public Workspace getOne(Long workspaceId) {
        // TODO: 워크스페이스 하나의 정보를 불러올 때,
        //  해당 워크스페이스의 소속 멤버 목록과 채널 목록을 함께 불러와야 함.
        //  이 때, pagination이 적용되어야 한다.
        Optional<Workspace> workspace = workspaceRepository.findById(workspaceId);
        if(workspace.isPresent()) {
            return workspace.get();
        } else {
            throw new BusinessException(StatusCode.WORKSPACE_WS_NOT_EXIST);
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
