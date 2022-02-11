package lastpunch.presence.repository;

import lastpunch.presence.entity.Presence;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PresenceRepository extends MongoRepository<Presence, String>, PresenceRepositoryCustom{
    List<Presence> findAllByWorkspaceId(String workspaceId);
    Optional<Presence> findByWorkspaceIdAndUserId(String workspaceId, String userId);
}

