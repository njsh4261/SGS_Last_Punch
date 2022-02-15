package lastpunch.workspace.controller;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.service.AccountChannelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/channel/member")
public class AccountChannelController{
    private final AccountChannelService accountChannelService;

    @Autowired
    public AccountChannelController(AccountChannelService accountChannelService){
        this.accountChannelService = accountChannelService;
    }

    // 채널에 새로운 멤버를 추가
    @PostMapping
    public ResponseEntity<Object> add(@RequestBody AccountChannel.Dto accountChannelDto){
        return Response.ok(ServerCode.WORKSPACE, accountChannelService.add(accountChannelDto));
    }

    // 채널 내 멤버의 권한을 변경
    // 권한을 가진 유저가 다른 멤버의 권한을 바꾸거나 채널 소유자가 다른 멤버에게 소유권을 양도할 때 사용
    @PutMapping
    public ResponseEntity<Object> edit(@RequestBody AccountChannel.Dto accountChannelDto){
        return Response.ok(ServerCode.WORKSPACE, accountChannelService.edit(accountChannelDto));
    }

    // 채널에서 멤버를 삭제
    // 권한을 가진 멤버가 다른 멤버를 강퇴하거나 채널에서 자진 탈퇴할 때 사용
    @DeleteMapping
    public ResponseEntity<Object> delete(
            @RequestParam(value = "accountId") Long accountId,
            @RequestParam(value = "channelId") Long channelId){
        return Response.ok(ServerCode.WORKSPACE, accountChannelService.delete(accountId, channelId));
    }
}
