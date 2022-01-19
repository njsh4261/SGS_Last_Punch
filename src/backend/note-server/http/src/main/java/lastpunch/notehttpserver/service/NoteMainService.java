package lastpunch.notehttpserver.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.GetNoteResponse;
import lastpunch.notehttpserver.entity.Block;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.repository.NoteRepository;
import lombok.RequiredArgsConstructor;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class NoteMainService {
    @Autowired
    MongoTemplate mongoTemplate;
    
    public void create(CreateNoteRequest createNoteRequest){
        Note newNote = createNoteRequest.toEntity();
        List<Block> blocks = new ArrayList<Block>();
        
        blocks.add(Block.builder()
            .id(createNoteRequest.getTitleBlockId())
            .type("title")
            .content(createNoteRequest.getTitle())
            .build()
        );
        newNote.setBlocks(blocks);
        mongoTemplate.insert(newNote);
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
}
