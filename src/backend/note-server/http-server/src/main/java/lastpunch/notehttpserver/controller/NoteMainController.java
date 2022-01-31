package lastpunch.notehttpserver.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.NoteInfo;
import lastpunch.notehttpserver.dto.GetNoteResponse;
import lastpunch.notehttpserver.service.NoteMainService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class NoteMainController {
    private final NoteMainService noteMainService;
    
    @PostMapping("/note")
    public ResponseEntity<Object> createNote(@RequestBody CreateNoteRequest createNoteRequest){
        String noteId = noteMainService.create(createNoteRequest);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("noteId", noteId);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, data);
    }
    
    @GetMapping("/notes")
    public ResponseEntity<Object> getNotes(@RequestParam Long channelId){
        List<NoteInfo> noteList = noteMainService.getList(channelId);

        Map<String, Object> data = new HashMap<String, Object>();
        data.put("noteList", noteList);

        return Response.toResponseEntity("15000", HttpStatus.OK, data);
    }

    @GetMapping("note/{id}")
    public ResponseEntity<Object> getNote(@PathVariable("id") String id){
        GetNoteResponse note = noteMainService.find(id);

        Map<String, Object> data = new HashMap<String, Object>();
        data.put("note", note);

        return Response.toResponseEntity("15000", HttpStatus.OK, data);
    }
}
