package lastpunch.presence.dto;

import lastpunch.presence.common.UserStatus;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class PresenceDto{
    private String workspaceId;
    private String userId;
    private UserStatus status;
}
