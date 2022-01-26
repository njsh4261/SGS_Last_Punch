package lastpunch.workspace.controller;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
    
    @PostMapping
    public ResponseEntity<Object> getAccountsByEmail(
            @RequestBody Account.FindDto accountFindDto,
            @PageableDefault Pageable pageable){
        return Response.ok(
            ServerCode.WORKSPACE,
            accountService.getByEmail(accountFindDto.getEmail(), pageable)
        );
    }
}
