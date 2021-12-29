package LastPunch.searchServer.service;

import LastPunch.searchServer.dto.UserDto;
import LastPunch.searchServer.repository.UserEsRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class SearchService {
    final private UserEsRepository userEsRepository;
    
    public List<UserDto> findByName(String name){
        return userEsRepository.findByNameContains(name);
    }
    
}
