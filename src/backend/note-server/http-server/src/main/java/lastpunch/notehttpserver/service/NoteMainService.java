package lastpunch.notehttpserver.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.NoteInfo;
import lastpunch.notehttpserver.dto.GetNoteResponse;
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
    
    public String create(CreateNoteRequest createNoteRequest){
        Note newNote = createNoteRequest.toEntity();
        return  mongoTemplate.insert(newNote).getId().toString();
    }
    
    public GetNoteResponse find(String id) {
        ObjectId noteId = new ObjectId(id);
        Note note = mongoTemplate.findById(noteId, Note.class);
        if(note == null){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
        return GetNoteResponse.builder()
            .id(note.getId().toString())
            .creatorId(note.getCreatorId())
            .title(note.getTitle())
            .content(note.getContent())
            .ops(note.getOps())
            .createDt(note.getCreateDt())
            .modifyDt(note.getModifyDt())
            .build();
    }
    
    // ToDo: 노트 계층 구조 반영된 목록 받아오기
    public List<NoteInfo> getList(Long channelId) {
        Query query = new Query(Criteria.where("channelId").is(channelId));
        List<Note> noteList = mongoTemplate.find(query, Note.class);
        return noteList.stream()
            .map(Note::toNoteInfo)
            .collect(Collectors.toList());
    }
}
