package lastpunch.chat.service;

import java.time.LocalDateTime;
import lastpunch.chat.entity.Message;
import lastpunch.chat.repository.MongoDbRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class MongoDbService{
    private final MongoDbRepository mongoDbRepository;
    private static final int page = 0;
    private static final int size = 30;
    
    @Autowired
    public MongoDbService(MongoDbRepository mongoDbRepository){
        this.mongoDbRepository = mongoDbRepository;
    }
    
    public Page<Message> getRecentMessages(String channelId){
        return mongoDbRepository.findAllByChannelIdOrderByCreateDtDesc(
            channelId, PageRequest.of(page, size)
        );
    }
    
    public Page<Message> getOlderMessages(String channelId, LocalDateTime dateTime){
        return mongoDbRepository.findOldMessages(channelId, dateTime, PageRequest.of(page, size));
    }
    
    @Async
    public void saveMessage(Message message){
        mongoDbRepository.save(message);
    }
}
