package lastpunch.workspace.controller;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.dto.WorkspaceDto;
import lastpunch.workspace.service.WorkspaceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/workspace")
public class WorkspaceController {
    private final WorkspaceService workspaceService;
    private final int pageSize = 5;

    @Autowired
    public WorkspaceController(WorkspaceService workspaceService) {
        this.workspaceService = workspaceService;
    }

    @GetMapping
    public ResponseEntity<Object> getWorkspaceList(
            @RequestParam("userId") Long userId, @PageableDefault(size = pageSize) Pageable pageable) {
        ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();
        return Response.ok(
                ServerCode.WORKSPACE,
                new ConcurrentHashMap<>().put("workspaces", workspaceService.getList(userId, pageable))
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getOneWorkspace(@PathVariable("id") Long id) {
        ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();
        map.put("workspace", workspaceService.getOne(id));
//        map.put("members", memberService.get());
        return Response.ok(ServerCode.WORKSPACE, map);
    }

    @PostMapping
    public ResponseEntity<Object> createWorkspace(@RequestBody WorkspaceDto workspaceDto) {
        workspaceService.createOne(workspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Object> editWorkspace(@RequestBody WorkspaceDto workspaceDto, @PathVariable("id") Long id) {
        workspaceService.editOne(workspaceDto, id);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteWorkspace(@PathVariable("id") Long id) {
        workspaceService.deleteOne(id);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
