package lastpunch.presence.repository;

import lastpunch.presence.common.UserStatus;
import lastpunch.presence.entity.Presence;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class PresenceRepositoryImpl implements PresenceRepositoryCustom{
    private final MongoTemplate mongoTemplate;
    private final Logger logger;
    
    @Autowired
    public PresenceRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
        this.logger = LoggerFactory.getLogger(PresenceRepositoryImpl.class);
    }

//    @Override
//    public Presence.User getUser(String workspaceId, String userId){
//        Aggregation aggregation = Aggregation.newAggregation(
//                Aggregation.unwind("users"),
//                Aggregation.match(
//                        Criteria.where("_id").is(workspaceId)
//                                .and("users.userId").is(userId)
//                ),
//                Aggregation.project()
//                        .and("users.userId").as("userId")
//                        .and("users.userStatus").as("userStatus")
//                        .and("users.sessions").as("sessions")
//
//        );
//
////        AggregationResults<UserOutput> aggregationResults = mongoTemplate.aggregate(
////                aggregation, "presences", UserOutput.class
////        );
////
////        List<UserOutput> list = aggregationResults.getMappedResults();
////        if(!list.isEmpty()){
////            UserOutput userOutput = list.get(0);
////            return Presence.User.builder()
////                    .userId(userOutput.getUserId())
////                    .userStatus(userOutput.getUserStatus())
////                    .sessions(userOutput.getSessions())
////                    .build();
////        }
////        return null;
//
//        AggregationResults<Presence.User> aggregationResults = mongoTemplate.aggregate(
//                aggregation, "presences", Presence.User.class
//        );
//
//        List<Presence.User> list = aggregationResults.getMappedResults();
//        return list.isEmpty() ? null : list.get(0);
//    }
//
//    @Getter
//    @AllArgsConstructor
//    private class UserOutput{
//        private String _id;
//        private String userId;
//        private UserStatus userStatus;
//        private List<String> sessions;
//    }

    //    @Override
//    public List<UpdateDto> findWorkspacePresence(String workspaceId){
//        Aggregation aggregation = Aggregation.newAggregation(
//            Aggregation.match(Criteria.where("workspaceId").is(workspaceId)),
//            Aggregation.sort(Direction.DESC, "modifyDt"),
//            Aggregation.group("userId").push("$$ROOT").as("presences"),
//            Aggregation.project().and("presences").slice(1)
//        );
//
//        AggregationResults<PresenceOutput> aggregationResults = mongoTemplate.aggregate(
//            aggregation, "presences", PresenceOutput.class
//        );
//
//        return aggregationResults.getMappedResults().stream()
//            .map(presenceOutput -> presenceOutput.getUserPresences().get(0).toDto())
//            .collect(Collectors.toList());
//    }
//
//    @Getter
//    @AllArgsConstructor
//    private static class PresenceOutput{
//        private String _id;
//        private List<UserPresence> userPresences;
//    }

//    @Override
//    public void saveOrUpdate(UpdateDto updateDto, String sessionId) {
//        Aggregation aggregation = Aggregation.newAggregation()
//        Presence presence = mongoTemplate.findById(updateDto.getWorkspaceId(), Presence.class);
//
//    }
//
//    @Override
//    public void saveAndUpdate(UserPresence userPresence){
//        mongoTemplate.save(userPresence);
//
//        Query query = new Query();
//        query.addCriteria(
//            Criteria.where("workspaceId").is(userPresence.getWorkspaceId())
//                .and("userId").is(userPresence.getUserId())
//        );
//        Update update = new Update();
//        update.set("userStatus", userPresence.getUserStatus());
//
//        UpdateResult updateResult = mongoTemplate.updateMulti(query, update, UserPresence.class);
//        logger.info("saveOrUpdate: " + updateResult.getMatchedCount() + " results");
//    }
}
