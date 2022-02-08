package lastpunch.notehttpserver.controller;

import java.util.List;
import java.util.Map;
import javax.ws.rs.DELETE;
import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.dto.NoteDto;
import lastpunch.notehttpserver.service.NoteMainService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class NoteMainController {
    private final NoteMainService noteMainService;
    
    @PostMapping("/note")
    public ResponseEntity<Object> create(@RequestBody NoteDto.createRequest request){
        
        String noteId = noteMainService.create(request);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, Map.of("noteId", noteId));
    }
    
    @GetMapping("/notes")
    public ResponseEntity<Object> getNotes(@RequestParam Long channelId){
        
        List<NoteDto.noteInfo> noteList = noteMainService.getList(channelId);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, Map.of("noteList", noteList));
    }

    @GetMapping("note/{id}")
    public ResponseEntity<Object> getNote(@PathVariable("id") String id){
        
        NoteDto.getResponse note = noteMainService.find(id);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, Map.of("note", note));
    }
    
    @DeleteMapping("note/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") String id){
        
        noteMainService.delete(id);
        
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
}
