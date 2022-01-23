package lastpunch.authserver.common;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.authserver.entity.Account;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

@Getter
@ToString
public class CustomUser extends User {
    private final Account account;
    
    public Account getAccount() {
        return account;
    }
    
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
