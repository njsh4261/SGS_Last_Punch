package lastpunch.chat.repository;

import java.time.LocalDateTime;
import java.util.List;
import lastpunch.chat.entity.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

@Repository
public class MongoDbRepositoryImpl implements MongoDbRepositoryCustom{
    private MongoTemplate mongoTemplate;
    private Logger logger;
    
    @Autowired
    public MongoDbRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
        this.logger = LoggerFactory.getLogger(MongoDbRepositoryImpl.class);
    }
    
    @Override
    public Page<Message> findOldMessages(String channelId, LocalDateTime dateTime, Pageable pageable){
        Query query = new Query()
            .addCriteria(Criteria.where("channelId").is(channelId))
            .addCriteria(Criteria.where("createDt").lt(dateTime))
            .with(Sort.by(Direction.DESC, "createDt"))
            .with(pageable);
        return new PageImpl<>(
            mongoTemplate.find(query, Message.class),
            pageable,
            mongoTemplate.count(query, Message.class)
        );
    }
}
