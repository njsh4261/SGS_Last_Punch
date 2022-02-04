package lastpunch.workspace.repository.message;

import java.util.List;
import java.util.Map;
import lastpunch.workspace.entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageRepository extends MongoRepository<Message, String>, MessageRepositoryCustom{
    Map<String, Message> getRecentDMs(List<String> dmList);
}
