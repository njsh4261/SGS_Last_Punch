package lastpunch.notehttpserver.service;

import com.mongodb.client.result.UpdateResult;
import java.util.List;
import java.util.Optional;
import lastpunch.notehttpserver.dto.BlockDto;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.UpdateNoteRequest;
import lastpunch.notehttpserver.entity.Block;
import lastpunch.notehttpserver.entity.Clock;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.repository.NoteRepository;
import lombok.RequiredArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class NoteUpdateService {
    @Autowired
    MongoTemplate mongoTemplate;
    
    public void update(UpdateNoteRequest updateNoteRequest){
        ObjectId noteId = new ObjectId(updateNoteRequest.getNote_id());
        List<BlockDto> transactions = updateNoteRequest.getTransactions();
        
        //ToDo: 효율적인 쿼리로 바꾸기 (Bulkwrite?)
        for (BlockDto block: transactions){
            Query query = new Query(Criteria.where("_id").is(new ObjectId(updateNoteRequest.getNote_id()))
                .and("content._id").is(new ObjectId(block.getId()))
            );
            Update update = new Update();
            update.set("content.$.text", block.getText());
            update.set("content.$.ver", block.getVer());
   
            UpdateResult updateResult = mongoTemplate.updateFirst(query, update, Note.class);
            
            
            if (updateResult.getModifiedCount() == 0){
                Query insertQuery = new Query().addCriteria(Criteria.where( "_id" ).is(new ObjectId(updateNoteRequest.getNote_id())));
                Update insertUpdate = new Update();
                Note note = mongoTemplate.findOne(insertQuery, Note.class);
    
                if (note != null) {
                    note.getContent().add(block.toEntity());
                    mongoTemplate.save(note);
                }
            }
        }
       
        
        
//        noteRepository.insert(createNoteRequest.toEntity());
    }
}
