package lastpunch.presence.service;

import java.util.List;
import java.util.stream.Collectors;
import lastpunch.presence.dto.PresenceDto;
import lastpunch.presence.repository.PresenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RedisService{
    private final PresenceRepository presenceRepository;
    
    @Autowired
    public RedisService(PresenceRepository presenceRepository){
        this.presenceRepository = presenceRepository;
    }
    
    public List<PresenceDto> getMemberPresence(String workspaceId){
        return presenceRepository.getWorkspacePresence(workspaceId).entrySet().stream()
            .map(
                entry -> PresenceDto.builder()
                    .workspaceId(workspaceId)
                    .userId(entry.getKey())
                    .status(entry.getValue())
                    .build()
            ).collect(Collectors.toList());
    }
}
