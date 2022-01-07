package LastPunch.searchServer.service;

import LastPunch.searchServer.dto.ChannelDto;
import LastPunch.searchServer.dto.UserDto;
import LastPunch.searchServer.dto.request.SearchRequest;
import LastPunch.searchServer.repository.ChannelEsRepository;
import LastPunch.searchServer.repository.UserEsRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class SearchService {
    final private UserEsRepository userEsRepository;
    final private ChannelEsRepository channelEsRepository;
    
    public List<UserDto> findMemberByName(SearchRequest request){
        System.out.println("request.getQuery() = " + request.getQuery());
        System.out.println("request = " + request.getWorkspace_id());
        return userEsRepository.findByNameContainsAndWorkspaceIdEquals(request.getQuery(),
            request.getWorkspace_id());
    }
    
//    public List<ChannelDto> findChannelByName(SearchRequest request){
//        return channelEsRepository.findByNameContainsAndWorkspace_id(request.getQuery(),
//            request.getWorkspace_id());
//    }
    
}
