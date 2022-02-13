package lastpunch.chat.repository;

import java.time.LocalDateTime;
import lastpunch.chat.entity.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface MongoDbRepositoryCustom{
    Page<Message> findRecentMessages(String channelId, Pageable pageable);
    Page<Message> findOldMessages(String channelId, LocalDateTime dateTime, Pageable pageable);
}
