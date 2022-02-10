package lastpunch.presence.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import lastpunch.presence.common.UserStatus;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "presences")
@Getter
@Setter
@Builder
public class Presence{
    @Id
    private String sessionId;
    
    private String workspaceId;
    private String userId;
    private UserStatus userStatus;
    
    @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
    private LocalDateTime modifyDt;
    
    @Getter
    @Builder
    public static class UpdateDto{
        private String workspaceId;
        private String userId;
        private String userStatus;
        
        public Presence toEntity(String sessionId){
            return Presence.builder()
                .sessionId(sessionId)
                .workspaceId(workspaceId)
                .userId(userId)
                .userStatus(UserStatus.toEnum(userStatus))
                .modifyDt(LocalDateTime.now())
                .build();
        }
    }
    
    public UpdateDto toDto(){
        return UpdateDto.builder()
            .workspaceId(workspaceId)
            .userId(userId)
            .userStatus(userStatus.toString())
            .build();
    }
}
