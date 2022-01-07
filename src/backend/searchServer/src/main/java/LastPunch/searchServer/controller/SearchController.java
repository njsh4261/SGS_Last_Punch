package LastPunch.searchServer.controller;

import LastPunch.searchServer.dto.ChannelDto;
import LastPunch.searchServer.dto.UserDto;
import LastPunch.searchServer.dto.request.SearchRequest;
import LastPunch.searchServer.service.SearchService;
import LastPunch.searchServer.util.ResponseHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<Object> searchMember(@RequestBody SearchRequest request) {
        Map<String, Object> data = new HashMap<String, Object>();
        List<UserDto> userList = searchService.findMemberByName(request);
        data.put("result", userList);
        return ResponseHandler.generate("13000", HttpStatus.OK, data);
    }
    
//    @PostMapping(value="/search/channel")
//    public ResponseEntity<Object> searchChannel(@RequestBody SearchRequest request) {
//        Map<String, Object> data = new HashMap<String, Object>();
//        List<ChannelDto> channelList = searchService.findChannelByName(request);
//        data.put("result", channelList);
//        return ResponseHandler.generate("13000", HttpStatus.OK, data);
//    }
}
