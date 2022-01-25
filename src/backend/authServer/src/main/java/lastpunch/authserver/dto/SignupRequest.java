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
    public Account toEntity() {
        return Account.builder()
            .email(email)
            .password(password)
            .name("default_name")
            .country("kor")
            .language("eng")
            .settings(1)
            .status("ROLE_USER")
            .level(3)
            .point(123)
            .build();
    }
}