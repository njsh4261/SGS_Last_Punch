package lastpunch.notehttpserver.repository;

import lastpunch.notehttpserver.entity.Note;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NoteRepository extends MongoRepository<Note, ObjectId> {
    
}
