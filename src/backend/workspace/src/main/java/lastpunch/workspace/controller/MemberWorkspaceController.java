package lastpunch.workspace.controller;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.dto.MemberWorkspaceDto;
import lastpunch.workspace.service.MemberWorkspaceService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/workspace/member")
public class MemberWorkspaceController {
    private MemberWorkspaceService memberWorkspaceService;

    public MemberWorkspaceController(MemberWorkspaceService memberWorkspaceService) {
        this.memberWorkspaceService = memberWorkspaceService;
    }

    @PostMapping
    public ResponseEntity<Object> addNewMemberToWorkspace(@RequestBody MemberWorkspaceDto memberWorkspaceDto){
        return Response.ok(
                ServerCode.WORKSPACE,
                new ConcurrentHashMap<>().put(
                        "memberWorkspace", memberWorkspaceService.addNewMemberToWorkspace(memberWorkspaceDto)
                )
        );
    }

    @DeleteMapping
    public ResponseEntity<Object> deleteMemberFromWorkspace(@RequestBody MemberWorkspaceDto memberWorkspaceDto){
        memberWorkspaceService.deleteMemberFromWorkspace(memberWorkspaceDto);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
