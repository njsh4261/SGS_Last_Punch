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
    
    @PostMapping
    public ResponseEntity<Object> add(@RequestBody AccountChannel.Dto accountChannelDto){
        return Response.ok(ServerCode.WORKSPACE, accountChannelService.add(accountChannelDto));
    }

    @PutMapping
    public ResponseEntity<Object> edit(@RequestBody AccountChannel.Dto accountChannelDto){
        return Response.ok(ServerCode.WORKSPACE, accountChannelService.edit(accountChannelDto));
    }

    @DeleteMapping
    public ResponseEntity<Object> delete(@RequestBody AccountChannel.Dto accountChannelDto){
        return Response.ok(ServerCode.WORKSPACE, accountChannelService.delete(accountChannelDto));
    }
}
