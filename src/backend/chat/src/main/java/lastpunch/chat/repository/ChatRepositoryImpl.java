package lastpunch.chat.repository;

import lastpunch.chat.entity.ChatMessage;
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

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

@Repository
public class ChatRepositoryImpl implements ChatRepositoryCustom{
    private final MongoTemplate mongoTemplate;
    
    @Autowired
    public ChatRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
    }
    
    @Override
    public Page<ChatMessage> findRecentMessages(String channelId, Pageable pageable){
        Query query = new Query()
            .addCriteria(Criteria.where("channelId").is(channelId))
            .with(Sort.by(Direction.DESC, "createDt"))
            .with(pageable);
    
        return getReversedPages(query, pageable);
    }
    
    @Override
    public Page<ChatMessage> findOldMessages(String channelId, LocalDateTime dateTime, Pageable pageable){
        Query query = new Query()
            .addCriteria(Criteria.where("channelId").is(channelId))
            .addCriteria(Criteria.where("createDt").lt(dateTime))
            .with(Sort.by(Direction.DESC, "createDt"))
            .with(pageable);
        
        return getReversedPages(query, pageable);
    }
    
    private Page<ChatMessage> getReversedPages(Query query, Pageable pageable){
        List<ChatMessage> chatMessageList = mongoTemplate.find(query, ChatMessage.class);
        Collections.reverse(chatMessageList);
        return new PageImpl<>(
            chatMessageList,
            pageable,
            mongoTemplate.count(query, ChatMessage.class)
        );
    }
}
