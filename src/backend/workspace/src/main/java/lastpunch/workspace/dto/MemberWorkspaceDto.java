package lastpunch.workspace.dto;

import lastpunch.workspace.entity.MemberWorkspace;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MemberWorkspaceDto{
    private Long memberId;
    private Long workspaceId;

    public MemberWorkspace toEntity(){
        return MemberWorkspace.builder()
                .memberId(memberId).workspaceId(workspaceId).build();
    }
}
