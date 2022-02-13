package lastpunch.notehttpserver.service;

import com.mongodb.client.result.DeleteResult;
import java.util.List;
import java.util.stream.Collectors;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.NoteDto;
import lastpunch.notehttpserver.dto.NoteDto.noteInfo;
import lastpunch.notehttpserver.entity.Note;
import lombok.RequiredArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class NoteMainService {
    @Autowired
    MongoTemplate mongoTemplate;
    
    public NoteDto.noteInfo create(NoteDto.createRequest request){
        Note newNote = request.toEntity();
        Note insertedNote = mongoTemplate.insert(newNote);
        return new noteInfo(insertedNote);
    }
    
    public NoteDto.getResponse find(String id) {
        ObjectId noteId = new ObjectId(id);
        Note note = mongoTemplate.findById(noteId, Note.class);
        if(note == null){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
        return new NoteDto.getResponse(note);
    }
    
    // ToDo: 노트 계층 구조 반영된 목록 받아오기
    public List<NoteDto.noteInfo> getList(Long channelId) {
        Query query = new Query(Criteria.where("channelId").is(channelId));
        List<Note> noteList = mongoTemplate.find(query, Note.class);
        return noteList.stream()
            .map(noteInfo::new)
            .collect(Collectors.toList());
    }
    
    public void delete(String id){
        ObjectId noteId = new ObjectId(id);
        Query query = new Query(Criteria.where("_id").is(noteId));
        DeleteResult result = mongoTemplate.remove(query, Note.class);
        System.out.println("result = " + result);
        if (result.getDeletedCount() == 0){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
    }
}
