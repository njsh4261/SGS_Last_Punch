package lastpunch.notehttpserver.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.NoteInfo;
import lastpunch.notehttpserver.dto.GetNoteResponse;
import lastpunch.notehttpserver.entity.Block;
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
        List<Block> blocks = new ArrayList<Block>();
        
        blocks.add(Block.builder()
            .id(createNoteRequest.getTitleBlockId())
            .type("title")
            .content(createNoteRequest.getTitle())
            .build()
        );
        newNote.setBlocks(blocks);
        
        Note insertedNote = mongoTemplate.insert(newNote);
        return insertedNote.getId().toString();
    }
    
    public GetNoteResponse find(String id) {
        ObjectId noteId = new ObjectId(id);
        Note foundNote = mongoTemplate.findById(noteId, Note.class);
        if(foundNote == null){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
        return GetNoteResponse.builder()
            .id(foundNote.getId().toString())
            .blocks(foundNote.getBlocks())
            .createdt(foundNote.getCreatedt())
            .modifydt(foundNote.getModifydt())
            .build();
    }
    
    // ToDo: 노트 계층 구조 반영된 목록 받아오기
    public List<NoteInfo> getList(Long channelId) {
        Query query = new Query(Criteria.where("channel_id").is(channelId));
        List<Note> noteList = mongoTemplate.find(query, Note.class);
        return noteList.stream()
            .map(Note::toNoteInfo)
            .collect(Collectors.toList());
    }
}
