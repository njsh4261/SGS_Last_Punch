package lastpunch.authserver.dto;

import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class EmailVerifyRequest {
    @NotBlank
    private String email;
    @NotBlank
    private String verifyCode;
}
