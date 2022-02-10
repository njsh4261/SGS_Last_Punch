package lastpunch.chat.repository;

import lastpunch.chat.entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MongoDbRepository extends MongoRepository<Message, String>, MongoDbRepositoryCustom{
}
