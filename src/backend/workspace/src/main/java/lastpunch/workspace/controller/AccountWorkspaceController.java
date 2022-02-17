package lastpunch.workspace.controller;

import java.util.Map;
import lastpunch.workspace.common.Parser;
import lastpunch.workspace.entity.AccountWorkspace.DtoImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.service.AccountWorkspaceService;

@RestController
@RequestMapping("/workspace/member")
public class AccountWorkspaceController{
    private final AccountWorkspaceService accountWorkspaceService;

    @Autowired
    public AccountWorkspaceController(AccountWorkspaceService accountWorkspaceService) {
        this.accountWorkspaceService = accountWorkspaceService;
    }

    // 워크스페이스에 새로운 멤버를 추가
    @PostMapping
    public ResponseEntity<Object> add(@RequestBody DtoImpl dtoImpl, @RequestHeader Map<String, Object> header){
        return Response.ok(accountWorkspaceService.add(dtoImpl, Parser.getHeaderId(header)));
    }

    // 워크스페이스 내 멤버의 권한을 변경
    // 권한을 가진 유저가 다른 멤버의 권한을 바꾸거나 워크스페이스 소유자가 다른 멤버에게 소유권을 양도할 때 사용
    @PutMapping
    public ResponseEntity<Object> edit(@RequestBody DtoImpl dtoImpl, @RequestHeader Map<String, Object> header){
        return Response.ok(accountWorkspaceService.edit(dtoImpl, Parser.getHeaderId(header)));
    }

    // 워크스페이스에서 멤버를 삭제
    // 권한을 가진 멤버가 다른 멤버를 강퇴하거나 워크스페이스에서 자진 탈퇴할 때 사용
    @DeleteMapping
    public ResponseEntity<Object> delete(
            @RequestParam(value = "accountId") Long accountId,
            @RequestParam(value = "workspaceId") Long workspaceId,
            @RequestHeader Map<String, Object> header){
        return Response.ok(
            accountWorkspaceService.delete(accountId, workspaceId, Parser.getHeaderId(header))
        );
    }
}
