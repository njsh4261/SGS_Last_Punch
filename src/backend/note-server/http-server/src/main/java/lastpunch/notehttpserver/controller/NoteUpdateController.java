package lastpunch.notehttpserver.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.common.exception.BusinessException;
import lastpunch.notehttpserver.common.exception.ErrorCode;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.NoteInfo;
import lastpunch.notehttpserver.dto.SaveOperationsRequest;
import lastpunch.notehttpserver.dto.SyncNoteRequest;
import lastpunch.notehttpserver.dto.UpdateNoteRequest;
import lastpunch.notehttpserver.entity.Op;
import lastpunch.notehttpserver.service.NoteMainService;
import lastpunch.notehttpserver.service.NoteUpdateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class NoteUpdateController {
    private final NoteUpdateService noteUpdateService;

    @PutMapping(value ="/note", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Object> saveContent(@RequestBody UpdateNoteRequest updateNoteRequest){

        noteUpdateService.saveContent(updateNoteRequest);

        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
    @PostMapping("/note/op")
    public ResponseEntity<Object> saveOperations(@RequestBody SaveOperationsRequest saveOperationsRequest){
        System.out.println("saveOperationsRequest.getTimestamp() = " + saveOperationsRequest.getTimestamp());
        noteUpdateService.saveOperations(saveOperationsRequest);
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
    @GetMapping("/note/{id}/op")
    public ResponseEntity<Object> getNotes(@RequestParam String timestamp, @PathVariable("id") String id){

        String op = noteUpdateService.findOps(timestamp, id);

        Map<String, Object> data = new HashMap<String, Object>();
        data.put("op", op);
    
        return Response.toResponseEntity("15000", HttpStatus.OK, data);
    }
}
