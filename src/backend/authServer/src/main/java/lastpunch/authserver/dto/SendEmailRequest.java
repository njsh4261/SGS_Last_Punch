package lastpunch.authserver.dto;

import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SendEmailRequest {
    @NotBlank
    private String email;
}
