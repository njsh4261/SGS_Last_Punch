package lastpunch.workspace.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.dto.AccountWorkspaceDto;
import lastpunch.workspace.service.AccountWorkspaceService;

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
        // TODO: 논의할 거리 - 새로운 멤버를 워크스페이스에 추가한 뒤 db에서 업데이트된 멤버 목록을 가져올 것인가?
        accountWorkspaceService.addNewMember(accountWorkspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }

    @DeleteMapping
    public ResponseEntity<Object> deleteMember(
            @RequestBody AccountWorkspaceDto accountWorkspaceDto){
        accountWorkspaceService.deleteMember(accountWorkspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
