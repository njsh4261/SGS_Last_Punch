package lastpunch.presence.service;

import java.util.List;
import java.util.Optional;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.entity.Presence.UpdateDto;
import lastpunch.presence.repository.PresenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class MongoService{
    private final PresenceRepository presenceRepository;
    
    @Autowired
    public MongoService(PresenceRepository presenceRepository){
        this.presenceRepository = presenceRepository;
    }
    
    public List<UpdateDto> getList(String workspaceId){
        return presenceRepository.findWorkspacePresence(workspaceId);
    }
    
    public Optional<Presence> getOne(String id){
        return presenceRepository.findById(id);
    }
    
    @Async
    public void save(Presence presence){
        presenceRepository.save(presence);
    }
    
    @Async
    public void delete(Presence presence){
        presenceRepository.delete(presence);
    }
}
