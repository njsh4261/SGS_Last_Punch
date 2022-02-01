package lastpunch.notehttpserver.service;

import com.mongodb.client.result.UpdateResult;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.SaveOperationsRequest;
import lastpunch.notehttpserver.dto.SyncNoteRequest;
import lastpunch.notehttpserver.dto.TitleDto;
import lastpunch.notehttpserver.dto.UpdateNoteRequest;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.entity.Op;
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
    
    public void saveContent(UpdateNoteRequest updateNoteRequest){
        ObjectId noteId = new ObjectId(updateNoteRequest.getNoteId());
        Query query = new Query(Criteria.where("_id").is(noteId));
        Update update = new Update();
        update.set("content", updateNoteRequest.getContent())
            .set("ops", new ArrayList<Op>())
            .set("title", updateNoteRequest.getTitle())
            .set("modifyDt", updateNoteRequest.getModifyDt());
        mongoTemplate.updateFirst(query, update, Note.class);
    }
    
    public void saveOperations(SaveOperationsRequest saveOperationsRequest){
        ObjectId noteId = new ObjectId(saveOperationsRequest.getNoteId());
        System.out.println(Date.from(Instant.parse(saveOperationsRequest.getTimestamp())));
        Op op = Op.builder()
            .op(saveOperationsRequest.getOp())
            .timestamp(Date.from(Instant.parse(saveOperationsRequest.getTimestamp())))
            .build();
        
        Query query = new Query(Criteria.where("_id").is(noteId));
        Update update = new Update();
        update.push("ops").value(op);
        mongoTemplate.updateFirst(query, update, Note.class);
    }
    
    public String findOps(String timestamp, String id){
        ObjectId noteId = new ObjectId(id);
        Query query = new Query(Criteria.where("_id").is(noteId).andOperator(Criteria.where("ops").elemMatch(Criteria.where("timestamp").is(Date.from(Instant.parse(timestamp))))));
        query.fields().include("ops.$");
        List<Note> note = mongoTemplate.find(query, Note.class);
        
        if(note.size() == 1){
            return note.get(0).getOps().get(0).getOp();
        }
        else{
            throw new BusinessException(ErrorCode.OPERATION_NOT_EXIST);
        }
    }
    
    public void saveTitle(TitleDto titleDto){
        ObjectId noteId = new ObjectId(titleDto.getNoteId());
        Query query = new Query(Criteria.where("_id").is(noteId));
        Update update = new Update();
        update.set("title", titleDto.getTitle());
        mongoTemplate.updateFirst(query, update, Note.class);
    }
    
    public String findTitle(String id){
        ObjectId noteId = new ObjectId(id);
        Query query = new Query(Criteria.where("_id").is(noteId));
        query.fields().include("title");
        Note note = mongoTemplate.findOne(query, Note.class);
        System.out.println("note = " + note);
        
        if(note == null){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
        else{
            return note.getTitle();
        }
    }
    
    
//    public void update(UpdateNoteRequest updateNoteRequest){
//        ObjectId noteId = new ObjectId(updateNoteRequest.getNoteId());
//        List<Transaction> transactions = updateNoteRequest.getTransactions();
//
//        //ToDo: 효율적인 쿼리로 바꾸기 (Bulkwrite?)
//        //현재 코드는 잘못된 op인지 확인하지 않음
//        for (Transaction transaction: transactions){
//            String blockId = transaction.getId();
//            switch(transaction.getOp()) {
//                case "insert":
//                    Query insertQuery = new Query().addCriteria(Criteria.where( "_id" ).is(noteId));
//                    Note note = mongoTemplate.findOne(insertQuery, Note.class);
//
//                    if (note != null) {
//                        note.getBlocks().add(transaction.getBlock());
//                        mongoTemplate.save(note);
//                    }
//                    break;
//
//                case "update":
//                    Query updateQuery = new Query(Criteria.where("_id").is(noteId)
//                        .and("blocks._id").is(blockId));
//                    Update update = new Update();
//                    update.set("blocks.$", transaction.getBlock());
//
//                    mongoTemplate.updateFirst(updateQuery, update, Note.class);
//                    break;
//
//                case "delete":
//                    Query deleteQuery = new Query(Criteria.where("_id").is(noteId));
//                    Update deleteUpdate = new Update();
//                    deleteUpdate.pull("blocks", new Query(Criteria.where("_id").is(blockId)));
//                    mongoTemplate.updateFirst(deleteQuery, deleteUpdate, Note.class);
//                    break;
//            }
//        }
//    }
//
//    public List<Block> find(SyncNoteRequest syncNoteRequest){
//        ObjectId noteId = new ObjectId(syncNoteRequest.getNoteId());
//        List<Block> blocks = new ArrayList<Block>();
//        //ToDo: 효율적인 쿼리로 바꾸기
//        for (String blockId: syncNoteRequest.getQueryBlockId()){
//            Query query = new Query(Criteria.where("_id").is(noteId).and("blocks._id").is(blockId));
//            query.fields().include("blocks.$");
//            List<Note> notes = mongoTemplate.find(query, Note.class);
//            if (notes.size() != 0)
//                blocks.add(notes.get(0).getBlocks().get(0));
//        }
//        return blocks;
//
//        mongoTemplate.find()
//        Note foundNote = mongoTemplate.findById(noteId, Note.class);
//        if(foundNote == null){
//            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
//        }
//    }
}
