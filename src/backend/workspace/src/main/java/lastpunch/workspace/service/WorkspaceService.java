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
    
    public Map<String, Object> getList(Long id, Pageable pageable) {
        List<AccountWorkspace> list = commonService.getAccount(id).getWorkspaces();
        int start = (int) pageable.getOffset();
        
        return Map.of(
            "workspaces",
                    // TODO: 제대로 pagination하는 방법인지 검증 필요
                    //       프론트에만 지정 갯수만큼 넘겨주고 실제로는 모든 ws 목록을 불러오는 것 같다.
                    list.subList(start, Math.min(list.size(), start + pageable.getPageSize()))
                    .stream().map(AccountWorkspace::getWorkspace).map(Workspace::export)
                    .collect(Collectors.toList())
        );
    }
    
    public Map<String, Object> getOne(
            Long workspaceId, Pageable channelPageable, Pageable memberPageable) {
//        Workspace workspace = commonService.getWorkspace(workspaceId);
//        List<AccountWorkspace> memberList = workspace.getAccounts();
//        int memberStart = (int) memberPageable.getOffset();
//
//        // TODO: 채널 관련 API 추가 시 채널 정보도 함께 불러올 것
//        return Map.of(
//            "workspace", workspace.export(),
//            "channels", null,
//            "members",
//                    memberList.subList(
//                        memberStart,
//                        Math.min(memberList.size(), memberStart + memberPageable.getPageSize()))
//                    .stream().map(AccountWorkspace::getAccount).map(Account::export)
//                    .collect(Collectors.toList())
//        );
        return Map.of(
            "workspace", workspaceRepository.getOneWorkspace(workspaceId)
        );
    }
    
    public Workspace create(Workspace.ImportDto workspaceDto){
        return workspaceRepository.save(workspaceDto.toEntity());
    }
    
    public Workspace edit(Workspace.ImportDto workspaceDto, Long id) {
        return workspaceRepository.save(workspaceDto.changeValues(commonService.getWorkspace(id)));
    }
    
    public void delete(Long id) {
        // 추후에 아카이빙 기능(삭제한 데이터를 별도의 DB에 백업)을 구현한다면,
        // status field를 "deleted" 등으로 수정하여 live server와 다른 DB 서버에 저장하는 기능 추가
        workspaceRepository.deleteById(id);
    }
}
