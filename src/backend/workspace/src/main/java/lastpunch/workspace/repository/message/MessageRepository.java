package lastpunch.workspace.repository.message;

import lastpunch.workspace.entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageRepository extends MongoRepository<Message, String>, MessageRepositoryCustom{
}
