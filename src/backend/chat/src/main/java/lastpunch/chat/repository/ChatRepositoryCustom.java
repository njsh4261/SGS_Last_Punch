package lastpunch.chat.repository;

import java.time.LocalDateTime;
import lastpunch.chat.entity.ChatMessage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ChatRepositoryCustom{
    Page<ChatMessage> findRecentMessages(String channelId, Pageable pageable);
    Page<ChatMessage> findOldMessages(String channelId, LocalDateTime dateTime, Pageable pageable);
}
