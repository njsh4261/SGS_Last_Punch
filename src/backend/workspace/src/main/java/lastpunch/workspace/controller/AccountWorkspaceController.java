package lastpunch.workspace.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<Object> delete(@RequestBody AccountWorkspace.Dto accountWorkspaceDto){
        return Response.ok(ServerCode.WORKSPACE, accountWorkspaceService.delete(accountWorkspaceDto));
    }
}
