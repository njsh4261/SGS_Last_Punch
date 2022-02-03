package lastpunch.notehttpserver.controller;

import java.util.Map;
import lastpunch.notehttpserver.common.Response;
import lastpunch.notehttpserver.dto.NoteDto;
import lastpunch.notehttpserver.dto.OpDto;
import lastpunch.notehttpserver.service.NoteUpdateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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
    public ResponseEntity<Object> saveContent(@RequestBody NoteDto.updateRequest request){

        noteUpdateService.saveContent(request);

        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
    @PostMapping("/note/op")
    public ResponseEntity<Object> saveOperations(@RequestBody OpDto.saveRequest request){
        
        noteUpdateService.saveOperations(request);
        
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
    
    @GetMapping("/note/{id}/op")
    public ResponseEntity<Object> getOperations(@RequestParam String timestamp, @PathVariable("id") String id){
        
        String op = noteUpdateService.findOps(timestamp, id);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, Map.of("op", op));
    }
    
    @GetMapping("/note/{id}/title")
    public ResponseEntity<Object> getTitle(@PathVariable("id") String id){
        
        String title = noteUpdateService.findTitle(id);
        
        return Response.toResponseEntity("15000", HttpStatus.OK, Map.of("title", title));
    }
    
    @PutMapping("/note/title")
    public ResponseEntity<Object> saveTitle(@RequestBody NoteDto.titleDto titleDto){
        
        noteUpdateService.saveTitle(titleDto);
        
        return Response.toResponseEntity("15000", HttpStatus.OK);
    }
}
