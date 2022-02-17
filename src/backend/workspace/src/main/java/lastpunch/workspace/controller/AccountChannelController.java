package lastpunch.workspace.controller;

import java.util.Map;
import lastpunch.workspace.common.Parser;
import lastpunch.workspace.common.Response;
import lastpunch.workspace.entity.AccountChannel.DtoImpl;
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
    public ResponseEntity<Object> add(@RequestBody DtoImpl dtoImpl, @RequestHeader Map<String, Object> header){
        return Response.ok(accountChannelService.add(dtoImpl, Parser.getHeaderId(header)));
    }

    // 채널 내 멤버의 권한을 변경
    // 권한을 가진 유저가 다른 멤버의 권한을 바꾸거나 채널 소유자가 다른 멤버에게 소유권을 양도할 때 사용
    @PutMapping
    public ResponseEntity<Object> edit(@RequestBody DtoImpl dtoImpl, @RequestHeader Map<String, Object> header){
        return Response.ok(accountChannelService.edit(dtoImpl, Parser.getHeaderId(header)));
    }

    // 채널에서 멤버를 삭제
    // 권한을 가진 멤버가 다른 멤버를 강퇴하거나 채널에서 자진 탈퇴할 때 사용
    @DeleteMapping
    public ResponseEntity<Object> delete(
            @RequestParam(value = "accountId") Long accountId,
            @RequestParam(value = "channelId") Long channelId,
            @RequestHeader Map<String, Object> header){
        return Response.ok(
            accountChannelService.delete(accountId, channelId, Parser.getHeaderId(header))
        );
    }
}
