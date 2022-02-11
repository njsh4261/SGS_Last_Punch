package lastpunch.presence.service;

import lastpunch.presence.common.UserStatus;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.repository.PresenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class MongoService{
    private final PresenceRepository presenceRepository;
    
    @Autowired
    public MongoService(PresenceRepository presenceRepository){
        this.presenceRepository = presenceRepository;
    }

    public List<Presence.ExportDto> getByWorkspaceId(String workspaceId){
        return presenceRepository.findAllByWorkspaceId(workspaceId).stream()
                .map(Presence::export).collect(Collectors.toList());
    }

    @Async
    public void saveOrUpdate(Presence.UpdateDto updateDto, String sessionId){
        Optional<Presence> optionalPresence = presenceRepository.findByWorkspaceIdAndUserId(
                updateDto.getWorkspaceId(), updateDto.getUserId()
        );

        if(optionalPresence.isEmpty()){
            // 현재 세션에 대한 기록이 없음; 해당 워크스페이스에 대한 새로운 상태 정보 기입
            presenceRepository.save(Presence.make(updateDto, sessionId));
        }
        else{
            // 해당 유저의 상태 정보 업데이트 (현재 세션 정보가 없다면 추가)
            Presence presence = optionalPresence.get();
            presence.setUserStatus(UserStatus.toEnum(updateDto.getUserStatus()));
            if(!presence.getSessions().contains(sessionId)){
                presence.getSessions().add(sessionId);
            }
            presenceRepository.save(presence);
        }
    }

    public List<Presence.UpdateDto> deleteOrUpdate(String sessionId){
        
    }
    
//    public Optional<UserPresence> getOne(String id){
//        return presenceRepository.findById(id);
//    }
//
//    @Async
//    public void saveOrUpdate(UpdateDto updateDto, String sessionId){
//        presenceRepository.saveOrUpdate(updateDto, sessionId);
//    }
//
//    @Async
//    public void delete(UserPresence userPresence){
//        presenceRepository.delete(userPresence);
//    }


}
