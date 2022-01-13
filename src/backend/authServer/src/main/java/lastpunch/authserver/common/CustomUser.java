package lastpunch.authserver.common;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import lastpunch.authserver.entity.Account;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

@Getter
public class CustomUser extends User {
    private final Account account;
    
    public CustomUser(Account account){
        super(account.getEmail(), account.getPassword(), getAuthorities(account.getStatus()));
        this.account = account;
    }
    
    private static Collection<? extends GrantedAuthority> getAuthorities(String role) {
        List<GrantedAuthority> authorityList = new ArrayList<>();
        authorityList.add(new SimpleGrantedAuthority(role));
        return authorityList;
    }
}
