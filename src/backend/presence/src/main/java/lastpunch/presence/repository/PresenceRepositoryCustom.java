package lastpunch.presence.repository;

import java.util.Optional;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.entity.Presence.UpdateDto;
import lastpunch.presence.repository.PresenceRepositoryImpl.UpdateType;

public interface PresenceRepositoryCustom{
    Optional<Presence> findBySessionId(String sessionId);
    void update(UpdateDto updateDto, String sessionId, UpdateType updateType);
    void deleteBySessionId(String sessionId);
}
