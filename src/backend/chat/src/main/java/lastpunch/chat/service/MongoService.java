package lastpunch.chat.service;

import lastpunch.chat.entity.ChatMessage;
import lastpunch.chat.entity.ChatMessage.GetOlderDto;
import lastpunch.chat.repository.ChatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class MongoService{
    private final ChatRepository chatRepository;
    private static final int page = 0;
    private static final int size = 30;
    
    @Autowired
    public MongoService(ChatRepository chatRepository){
        this.chatRepository = chatRepository;
    }
    
    public Page<ChatMessage> getRecentMessages(String channelId){
        return chatRepository.findRecentMessages(channelId, PageRequest.of(page, size));
    }
    
    public Page<ChatMessage> getOldMessages(GetOlderDto getOlderDto){
        return chatRepository.findOldMessages(
            getOlderDto.getChannelId(), getOlderDto.getDateTime(), PageRequest.of(page, size)
        );
    }
    
    @Async
    public void saveMessage(ChatMessage chatMessage){
        chatRepository.save(chatMessage);
    }
}
