package lastpunch.chat.service;

import lastpunch.chat.entity.Message;
import lastpunch.chat.entity.Message.GetOlderDto;
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
    
    public Page<Message> getOldMessages(GetOlderDto getOlderDto){
        return mongoDbRepository.findOldMessages(
            getOlderDto.getChannelId(), getOlderDto.getDateTime(), PageRequest.of(page, size)
        );
    }
    
    @Async
    public void saveMessage(Message message){
        mongoDbRepository.save(message);
    }
}
