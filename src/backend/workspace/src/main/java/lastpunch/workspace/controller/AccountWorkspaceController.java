package lastpunch.workspace.controller;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.dto.AccountWorkspaceDto;
import lastpunch.workspace.entity.Workspace;
import lastpunch.workspace.service.AccountWorkspaceService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/workspace/member")
public class AccountWorkspaceController{
    private final AccountWorkspaceService accountWorkspaceService;

    public AccountWorkspaceController(AccountWorkspaceService accountWorkspaceService) {
        this.accountWorkspaceService = accountWorkspaceService;
    }

    @PostMapping
    public ResponseEntity<Object> addNewMember(
        @RequestBody AccountWorkspaceDto accountWorkspaceDto){
        return Response.ok(
            ServerCode.WORKSPACE,
            new ConcurrentHashMap<>().put(
                "workspace", accountWorkspaceService.addNewMember(accountWorkspaceDto)
            )
        );
    }

    @DeleteMapping
    public ResponseEntity<Object> deleteMember(
        @RequestBody AccountWorkspaceDto accountWorkspaceDto){
        accountWorkspaceService.deleteMember(accountWorkspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
