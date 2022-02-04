package lastpunch.workspace.repository.message;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lastpunch.workspace.entity.Message;
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
public class MessageRepositoryImpl implements MessageRepositoryCustom{
    private final MongoTemplate mongoTemplate;
    private final Logger logger;
    
    @Autowired
    public MessageRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
        this.logger = LoggerFactory.getLogger(MessageRepositoryImpl.class);
    }
    
    @Override
    public Map<String, Message> getRecentDMs(List<String> dmList){
        Aggregation aggregation = Aggregation.newAggregation(
            Aggregation.match(Criteria.where("channelId").in(dmList)),
            Aggregation.sort(Direction.DESC, "createDt"),
            Aggregation.group("channelId").push("$$ROOT").as("messages"),
            Aggregation.project().and("messages").slice(1)
        );
    
        AggregationResults<DmOutput> aggregationResults = mongoTemplate.aggregate(
            aggregation, "messages", DmOutput.class
        );
    
        HashMap<String, Message> map = new HashMap<>();
        for(DmOutput dmOutput: aggregationResults.getMappedResults()){
            map.put(
                dmOutput.getId(), (
                    dmOutput.getMessages().size() > 0 ? dmOutput.getMessages().get(0) : null
                )
            );
        }
        return map;
    }
    
    @Getter
    private class DmOutput{
        private String id;
        private List<Message> messages;
    }
}
