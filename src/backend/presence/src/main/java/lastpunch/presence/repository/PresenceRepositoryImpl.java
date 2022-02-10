package lastpunch.presence.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.entity.Presence.UpdateDto;
import lombok.Getter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

@Repository
public class PresenceRepositoryImpl implements PresenceRepositoryCustom{
    private final MongoTemplate mongoTemplate;
    private final Logger logger;
    
    @Autowired
    public PresenceRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
        this.logger = LoggerFactory.getLogger(PresenceRepositoryImpl.class);
    }
    
    @Override
    public List<UpdateDto> findWorkspacePresence(String workspaceId){
        Aggregation aggregation = Aggregation.newAggregation(
            Aggregation.match(Criteria.where("workspaceId").is(workspaceId)),
            Aggregation.sort(Direction.DESC, "modifyDt"),
            Aggregation.group("userId").push("$$ROOT").as("presences"),
            Aggregation.project().and("presences").slice(1)
        );
    
        AggregationResults<PresenceOutput> aggregationResults = mongoTemplate.aggregate(
            aggregation, "presences", PresenceOutput.class
        );
        
        return aggregationResults.getMappedResults().stream()
            .map(presenceOutput -> presenceOutput.getPresences().get(0).toDto())
            .collect(Collectors.toList());
    }
    
    @Getter
    private class PresenceOutput{
        private String _id;
        private List<Presence> presences;
    }
}
