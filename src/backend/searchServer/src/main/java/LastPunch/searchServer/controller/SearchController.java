package LastPunch.searchServer.controller;

import LastPunch.searchServer.document.User;
import LastPunch.searchServer.repository.UserEsRepository;
import LastPunch.searchServer.util.ResponseHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class SearchController {
    private final UserEsRepository userEsRepository;

    @GetMapping(value="/users/{name}")
    public ResponseEntity<Object> search(@PathVariable String name) {
        Map<String, Object> data = new HashMap<String, Object>();
        List<User> userList = userEsRepository.findByUsernameContains(name);
        data.put("result", userList);
        return ResponseHandler.generate("13000", HttpStatus.OK, data);
    }
}
