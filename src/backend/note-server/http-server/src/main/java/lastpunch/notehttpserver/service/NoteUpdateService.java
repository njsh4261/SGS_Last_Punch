package lastpunch.notehttpserver.service;

import com.mongodb.client.result.UpdateResult;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.NoteDto;
import lastpunch.notehttpserver.dto.NoteDto.updateRequest;
import lastpunch.notehttpserver.dto.OpDto.saveRequest;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.entity.Op;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class NoteUpdateService {
    @Autowired
    MongoTemplate mongoTemplate;
    
    public void saveContent(updateRequest request){
        ObjectId noteId = new ObjectId(request.getNoteId());
        
        Query query = new Query(Criteria.where("_id").is(noteId));
        Update update = new Update();
        update.set("content", request.getContent())
            .set("ops", new ArrayList<Op>())
            .set("title", request.getTitle())
            .set("modifyDt", request.getModifyDt());
        
        UpdateResult updateResult = mongoTemplate.updateFirst(query, update, Note.class);
        log.info(request.toString());
        log.info(updateResult.toString());
    }
    
    public void saveOperations(saveRequest request){
        ObjectId noteId = new ObjectId(request.getNoteId());
        Op op = request.toEntity();
        
        Query query = new Query(Criteria.where("_id").is(noteId));
        Update update = new Update();
        update.push("ops").value(op);
        
        UpdateResult updateResult = mongoTemplate.updateFirst(query, update, Note.class);
        log.info(op.toString());
        log.info(updateResult.toString());
    }
    
    public String findOps(String timestamp, String id){
        ObjectId noteId = new ObjectId(id);
        Query query = new Query(Criteria.where("_id").is(noteId)
            .andOperator(Criteria.where("ops").elemMatch(Criteria.where("timestamp").is(Date.from(Instant.parse(timestamp))))));
        query.fields().include("ops.$");
        List<Note> note = mongoTemplate.find(query, Note.class);
        
        if(note.size() == 1){
            return note.get(0).getOps().get(0).getOp();
        }
        else{
            throw new BusinessException(ErrorCode.OPERATION_NOT_EXIST);
        }
    }
    
    public void saveTitle(NoteDto.titleDto titleDto){
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
        
        if(note == null){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
        else{
            return note.getTitle();
        }
    }
}
