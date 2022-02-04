package lastpunch.authserver.dto;

import javax.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Data
@Builder
public class LoginResponse {
    private String accessToken;
    private String refreshToken;
    private AccountInfo accountInfo;
}
