package lastpunch.workspace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.service.AccountWorkspaceService;

@RestController
@RequestMapping("/workspace/member")
public class AccountWorkspaceController{
    private final AccountWorkspaceService accountWorkspaceService;

    @Autowired
    public AccountWorkspaceController(AccountWorkspaceService accountWorkspaceService) {
        this.accountWorkspaceService = accountWorkspaceService;
    }

    @PostMapping
    public ResponseEntity<Object> add(@RequestBody AccountWorkspace.Dto accountWorkspaceDto){
        return Response.ok(ServerCode.WORKSPACE, accountWorkspaceService.add(accountWorkspaceDto));
    }
    
    @PutMapping
    public ResponseEntity<Object> edit(@RequestBody AccountWorkspace.Dto accountWorkspaceDto){
        return Response.ok(ServerCode.WORKSPACE, accountWorkspaceService.edit(accountWorkspaceDto));
    }

    @DeleteMapping
    public ResponseEntity<Object> delete(
            @RequestParam(value = "accountId") Long accountId,
            @RequestParam(value = "channelId") Long channelId){
        return Response.ok(ServerCode.WORKSPACE, accountWorkspaceService.delete(accountId, channelId));
    }
}
