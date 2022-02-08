package lastpunch.workspace.controller;

import java.util.Map;

import lastpunch.workspace.common.Parser;
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
    private static final int PAGE_SIZE_WORKSPACE = 5;
    private static final int PAGE_SIZE_CHANNEL = 10;
    private static final int PAGE_SIZE_MEMBER = 10;

    @Autowired
    public WorkspaceController(WorkspaceService workspaceService){
        this.workspaceService = workspaceService;
    }

    @GetMapping
    public ResponseEntity<Object> getList(
            @RequestHeader Map<String, Object> header,
            @PageableDefault(size = PAGE_SIZE_WORKSPACE) Pageable pageable){
        return Response.ok(
            ServerCode.WORKSPACE,
            workspaceService.getList(Parser.getHeaderId(header), pageable)
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getOne(@PathVariable("id") Long id){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getOne(id));
    }

    @GetMapping("/{id}/members")
    public ResponseEntity<Object> getAllMembers(@PathVariable("id") Long id){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getAllMembers(id));
    }

    @GetMapping("/{id}/members/paging")
    public ResponseEntity<Object> getMembersPaging(
            @PathVariable("id") Long id,
            @PageableDefault(size = PAGE_SIZE_MEMBER) Pageable pageable){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getMembersPaging(id, pageable));
    }

    @GetMapping("/{id}/channels")
    public ResponseEntity<Object> getAllChannels(@PathVariable("id") Long id){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getAllChannels(id));
    }

    @GetMapping("/{id}/channels/paging")
    public ResponseEntity<Object> getChannelsPaging(
            @PathVariable("id") Long id,
            @PageableDefault(size = PAGE_SIZE_CHANNEL) Pageable pageable){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.getChannelsPaging(id, pageable));
    }

    @PostMapping
    public ResponseEntity<Object> create(
            @RequestHeader Map<String, Object> header,
            @RequestBody Workspace.CreateDto createDto){
        return Response.ok(
            ServerCode.WORKSPACE,
            workspaceService.create(Parser.getHeaderId(header), createDto)
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<Object> edit(
            @RequestBody Workspace.EditDto workspaceDto, @PathVariable("id") Long id){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.edit(workspaceDto, id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") Long id){
        return Response.ok(ServerCode.WORKSPACE, workspaceService.delete(id));
    }
}
