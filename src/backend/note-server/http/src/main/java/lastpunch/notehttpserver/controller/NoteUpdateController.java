package lastpunch.notehttpserver.controller;


import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.dto.CreateNoteRequest;
import lastpunch.notehttpserver.dto.UpdateNoteRequest;
import lastpunch.notehttpserver.service.NoteMainService;
import lastpunch.notehttpserver.service.NoteUpdateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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
        System.out.println("updateNoteRequest = " + updateNoteRequest);
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
}
