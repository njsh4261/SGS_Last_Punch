package lastpunch.presence.repository;

import lastpunch.presence.entity.Presence;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PresenceRepository extends MongoRepository<Presence, String>, PresenceRepositoryCustom{
}
