package lastpunch.workspace.controller;

import java.util.Map;
import lastpunch.workspace.common.Parser;
import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/account")
public class AccountController{
    private AccountService accountService;
    
    @Autowired
    public AccountController(AccountService accountService){
        this.accountService = accountService;
    }
    
    @GetMapping("/self")
    public ResponseEntity<Object> getSelf(@RequestHeader Map<String, Object> header){
        return Response.ok(
            ServerCode.WORKSPACE,
            accountService.getSelf(Parser.getHeaderId(header))
        );
    }
    
    @PostMapping("/find")
    public ResponseEntity<Object> getAccountsByEmail(
            @RequestBody Account.FindDto accountFindDto,
            @PageableDefault Pageable pageable,
            @RequestHeader Map<String, Object> header){
        return Response.ok(
            ServerCode.WORKSPACE,
            accountService.getByEmail(
                accountFindDto.getEmail(), pageable , Parser.getHeaderId(header)
            )
        );
    }
}
