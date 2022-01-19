package lastpunch.notehttpserver.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.GetNoteResponse;
import lastpunch.notehttpserver.service.NoteMainService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/note")
@RestController
public class NoteMainController {
    private final NoteMainService noteMainService;
    
    @PostMapping
    public ResponseEntity<Object> createNote(@RequestBody CreateNoteRequest createNoteRequest){
        noteMainService.create(createNoteRequest);
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Object> getNote(@PathVariable("id") String id){
        GetNoteResponse note = noteMainService.find(id);
        
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("note", note);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, data);
    }
}
