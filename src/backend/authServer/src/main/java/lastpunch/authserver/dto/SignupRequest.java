package lastpunch.authserver.dto;

import javax.validation.constraints.NotBlank;
import lastpunch.authserver.entity.Account;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@RequiredArgsConstructor
@Setter
@Getter
public class SignupRequest {
    @NotBlank
    private String email;
    @NotBlank
    private String password;
    @NotBlank
    private String verifyCode;
    @NotBlank
    private String name;
    
    public Account toEntity() {
        return Account.builder()
            .email(email)
            .password(password)
            .name(name)
            .country("kor")
            .status("ROLE_USER")
            .build();
    }
}