package lastpunch.notehttpserver.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.SyncNoteRequest;
import lastpunch.notehttpserver.dto.UpdateNoteRequest;
import lastpunch.notehttpserver.entity.Block;
import lastpunch.notehttpserver.service.NoteMainService;
import lastpunch.notehttpserver.service.NoteUpdateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class NoteUpdateController {
    private final NoteUpdateService noteUpdateService;
    
    @PostMapping(value ="/note/save-transactions", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> saveTransactions(@RequestBody UpdateNoteRequest updateNoteRequest){
        
        noteUpdateService.update(updateNoteRequest);
        
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
    @GetMapping(value ="/note/sync-note")
    public ResponseEntity<Object> syncNote(@RequestBody SyncNoteRequest syncNoteRequest){
        
        List<Block> blocks = noteUpdateService.find(syncNoteRequest);
    
        Map<String, List<Block>> data = new HashMap<String, List<Block>>();
        data.put("blocks", blocks);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, data);
    }
}
