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
                .userStatus(UserStatus.ONLINE) // 사용자가 서비스에 처음 로그인하는 경우 상태를 ONLINE으로 설정
                .sessions(List.of(sessionId))
                .build();
    }
}
