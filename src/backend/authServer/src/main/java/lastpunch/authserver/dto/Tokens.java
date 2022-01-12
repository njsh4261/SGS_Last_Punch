package lastpunch.authserver.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Tokens {
    String accessToken;
    String refreshToken;
}