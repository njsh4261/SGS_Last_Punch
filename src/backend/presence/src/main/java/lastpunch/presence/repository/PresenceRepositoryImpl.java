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
            default: //UPDATE_STATUS
                // 사용자가 하나의 계정으로 여러 세션에서 로그인/로그아웃 하는 것은 사용자의 상태 정보를 바꾸지 않음
                // 기존에 접속한 세션에서 명시적으로 상태 정보를 바꾸는 경우에만 업데이트
                update.set("userStatus", UserStatus.toEnum(updateDto.getUserStatus()));
                break;
        }
        
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
