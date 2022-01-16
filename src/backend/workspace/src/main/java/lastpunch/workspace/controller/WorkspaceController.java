package lastpunch.workspace.controller;

import java.util.List;
import java.util.Map;
import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.dto.WorkspaceDto;
import lastpunch.workspace.dto.WorkspaceExportDto;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.service.WorkspaceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/workspace")
public class WorkspaceController{
    private final WorkspaceService workspaceService;
    private static final int PAGESIZE = 5;

    @Autowired
    public WorkspaceController(WorkspaceService workspaceService){
        this.workspaceService = workspaceService;
    }

    @GetMapping
    public ResponseEntity<Object> getWorkspaceList(
            @RequestParam("userId") Long userId, @PageableDefault(size = PAGESIZE) Pageable pageable){
        // TODO: pagination을 적용하여 하나의 사용자의 워크스페이스 목록의 일부를 불러오고,
        //  해당 워크스페이스의 멤버의 목록 중 5명 정도씩만을 각각 불러와야 한다.
        //  현재는 하나의 사용자의 워크스페이스의 목록 전체, 해당 워크스페이스의 멤버 전체 목록을 가져오는 식.
//        List<WorkspaceExportDto> workspaces = workspaceService.getList(userId, pageable);
//        ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();
//        map.put("workspaces", workspaces);
        
        return Response.ok(
                ServerCode.WORKSPACE,
                Map.of("workspaces", workspaceService.getList(userId, pageable))
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getOneWorkspace(@PathVariable("id") Long id){
        ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();
        map.put("workspace", workspaceService.getOne(id));
        return Response.ok(ServerCode.WORKSPACE, map);
    }

    @PostMapping
    public ResponseEntity<Object> createWorkspace(@RequestBody WorkspaceDto workspaceDto){
        workspaceService.createOne(workspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Object> editWorkspace(
            @RequestBody WorkspaceDto workspaceDto, @PathVariable("id") Long id){
        workspaceService.editOne(workspaceDto, id);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteWorkspace(@PathVariable("id") Long id){
        workspaceService.deleteOne(id);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
