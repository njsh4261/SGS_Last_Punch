package lastpunch.presence.entity;


import lastpunch.presence.common.UserStatus;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "presences")
@Getter
@Setter
@Builder
public class Presence{
    private String workspaceId;
    private String userId;
    private UserStatus userStatus;
    private List<String> sessions;

    @Getter
    @Builder
    public static class UpdateDto{
        private String workspaceId;
        private String userId;
        private String userStatus;
    }

    public UpdateDto export(){
        return UpdateDto.builder()
                .workspaceId(workspaceId)
                .userId(userId)
                .userStatus(userStatus.toString())
                .build();
    }

    public static Presence make(UpdateDto updateDto, String sessionId){
        return Presence.builder()
                .workspaceId(updateDto.getWorkspaceId())
                .userId(updateDto.getUserId())
                .userStatus(UserStatus.toEnum(updateDto.getUserStatus()))
                .sessions(List.of(sessionId))
                .build();
    }
}
