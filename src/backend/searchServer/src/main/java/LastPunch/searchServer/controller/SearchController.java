package LastPunch.searchServer.controller;

import LastPunch.searchServer.dto.UserDto;
import LastPunch.searchServer.dto.request.SearchMemberRequest;
import LastPunch.searchServer.repository.UserEsRepository;
import LastPunch.searchServer.service.SearchService;
import LastPunch.searchServer.util.ResponseHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class SearchController {
    private final SearchService searchService;

    @PostMapping(value="/search/member")
    public ResponseEntity<Object> search(@RequestBody SearchMemberRequest request) {
        System.out.println("query = " + request.getQuery());
        Map<String, Object> data = new HashMap<String, Object>();
        List<UserDto> userList = searchService.findByName(request.getQuery());
        data.put("result", userList);
        return ResponseHandler.generate("13000", HttpStatus.OK, data);
    }
}
