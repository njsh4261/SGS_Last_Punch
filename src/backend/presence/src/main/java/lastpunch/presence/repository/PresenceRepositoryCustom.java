package lastpunch.presence.repository;

import lastpunch.presence.dto.UpdateDto;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.entity.Presence.User;

import java.util.List;

public interface PresenceRepositoryCustom{
//    List<UpdateDto> findWorkspacePresence(String workspaceId);
//    User getUser(String workspaceId, String userId);
//    void saveOrUpdate(UpdateDto updateDto, String sessionId);
//    void deleteAndUpdateRest(UserPresence userPresence);
    List<Presence> findBySessionId(String sessionId);
}
