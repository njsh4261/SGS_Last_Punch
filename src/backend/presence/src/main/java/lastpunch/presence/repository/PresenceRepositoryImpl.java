package lastpunch.presence.repository;

import java.util.Optional;
import lastpunch.presence.common.UserStatus;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.entity.Presence.UpdateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Repository;

@Repository
public class PresenceRepositoryImpl implements PresenceRepositoryCustom{
    private final MongoTemplate mongoTemplate;
    
    @Autowired
    public PresenceRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
    }
    
    @Override
    public Optional<Presence> findBySessionId(String sessionId){
        return Optional.ofNullable(
            mongoTemplate.findOne(
                new Query(Criteria.where("sessions").is(sessionId)),
                Presence.class
            )
        );
    }
    
    @Override
    public void update(UpdateDto updateDto, String sessionId, UpdateType updateType){
        Update update = new Update();
        switch(updateType){
            case ADD_SESSION:
                update.addToSet("sessions", sessionId);
                break;
            case DELETE_SESSION:
                update.pull("sessions", sessionId);
                break;
            default:
                break;
        }
        update.set("userStatus", UserStatus.toEnum(updateDto.getUserStatus()));
        
        mongoTemplate.updateMulti(
            Query.query(
                Criteria.where("workspaceId").is(updateDto.getWorkspaceId())
                    .and("userId").is(updateDto.getUserId())
            ),
            update,
            Presence.class
        );
    }
    
    @Override
    public void deleteBySessionId(String sessionId){
        mongoTemplate.remove(
            new Query(Criteria.where("sessions").is(sessionId)),
            Presence.class
        );
    }
    
    public enum UpdateType{
        UPDATE_STATUS, ADD_SESSION, DELETE_SESSION
    }
}
