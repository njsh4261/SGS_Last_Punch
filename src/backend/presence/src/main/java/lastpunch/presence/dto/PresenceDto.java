package lastpunch.presence.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class PresenceDto{
    private String workspaceId;
    private String userId;
    private String status; // TODO: Enum UserStatus로 변경
}
