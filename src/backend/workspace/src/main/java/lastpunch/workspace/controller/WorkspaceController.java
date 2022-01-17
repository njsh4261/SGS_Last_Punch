package lastpunch.workspace.controller;

import lastpunch.workspace.entity.Workspace;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
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
    public ResponseEntity<Object> getOne(
            @PathVariable("id") Long id,
            @Qualifier("channel") @PageableDefault(size = PAGESIZE) Pageable channelPageable,
            @Qualifier("member") @PageableDefault(size = PAGESIZE) Pageable memberPageable){
        return Response.ok(
            ServerCode.WORKSPACE, workspaceService.getOne(id, channelPageable, memberPageable)
        );
    }

    @PostMapping
    public ResponseEntity<Object> create(@RequestBody Workspace.ImportDto workspaceDto){
        workspaceService.create(workspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Object> edit(
            @RequestBody Workspace.ImportDto workspaceDto, @PathVariable("id") Long id){
        workspaceService.edit(workspaceDto, id);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") Long id){
        workspaceService.delete(id);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
