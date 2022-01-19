package lastpunch.workspace.controller;

import lastpunch.workspace.entity.Channel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.service.WorkspaceService;

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
    public ResponseEntity<Object> getList(
            @RequestParam("userId") Long id, @PageableDefault(size = PAGESIZE) Pageable pageable){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getList(id, pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getOne(@PathVariable("id") Long id){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getOne(id));
    }

    @GetMapping("/{id}/members")
    public ResponseEntity<Object> getMembers(
            @PathVariable("id") Long id, @PageableDefault(size = PAGESIZE) Pageable pageable){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getMembers(id, pageable));
    }

    @GetMapping("/{id}/channels")
    public ResponseEntity<Object> getChannels(
            @PathVariable("id") Long id, @PageableDefault(size = PAGESIZE) Pageable pageable){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getChannels(id, pageable));
    }

    @PostMapping
    public ResponseEntity<Object> create(@RequestBody Workspace.CreateDto createDto){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.create(createDto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Object> edit(
            @RequestBody Workspace.EditDto workspaceDto, @PathVariable("id") Long id){
        workspaceService.edit(workspaceDto, id);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") Long id){
        workspaceService.delete(id);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
