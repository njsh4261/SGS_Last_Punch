package lastpunch.presence.repository;

import java.util.List;
import lastpunch.presence.entity.Presence.UpdateDto;

public interface PresenceRepositoryCustom{
    List<UpdateDto> findWorkspacePresence(String workspaceId);
}
