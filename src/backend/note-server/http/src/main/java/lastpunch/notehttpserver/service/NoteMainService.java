package lastpunch.notehttpserver.service;

import java.util.Optional;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.GetNoteResponse;
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
    private final NoteRepository noteRepository;
    
    public void create(CreateNoteRequest createNoteRequest){
        noteRepository.insert(createNoteRequest.toEntity());
    }
    
    public GetNoteResponse find(String id) {
        ObjectId noteId = new ObjectId(id);
        Optional<Note> noteOptional = noteRepository.findById(noteId);
        if(noteOptional.isEmpty()){
            throw new BusinessException(ErrorCode.NOTE_NOT_EXIST);
        }
        Note note = noteOptional.get();
        return GetNoteResponse.builder()
            .id(note.getId().toString())
            .title(note.getTitle())
            .createdt(note.getCreatedt())
            .modifydt(note.getModifydt())
            .build();
    }
}
