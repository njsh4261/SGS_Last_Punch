package lastpunch.authserver.dto;

import javax.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@RequiredArgsConstructor
@Setter
@Getter
public class LoginRequest {
    @NotBlank
    private String email;
    @NotBlank
    private String password;
}
