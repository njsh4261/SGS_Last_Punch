package lastpunch.chat.repository;

import lastpunch.chat.entity.ChatMessage;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatRepository
    extends MongoRepository<ChatMessage, String>, ChatRepositoryCustom{
}
