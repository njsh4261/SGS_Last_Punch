package lastpunch.presence.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lastpunch.presence.common.UserStatus;
import lastpunch.presence.entity.Presence;
import lastpunch.presence.repository.PresenceRepository;
import lastpunch.presence.repository.PresenceRepositoryImpl.UpdateType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class MongoService{
    private final PresenceRepository presenceRepository;
    private final Logger logger;
    
    @Autowired
    public MongoService(PresenceRepository presenceRepository){
        this.presenceRepository = presenceRepository;
        this.logger = LoggerFactory.getLogger(MongoService.class);
    }

    public List<Presence.UpdateDto> getByWorkspaceId(String workspaceId){
        return presenceRepository.findAllByWorkspaceId(workspaceId).stream()
                .map(Presence::export).collect(Collectors.toList());
    }
    
    // 메시지 전송을 blocking하지 않고 DB에 저장
    @Async
    public void saveOrUpdate(Presence.UpdateDto updateDto, String sessionId){
        Optional<Presence> optionalPresence = presenceRepository.findByWorkspaceIdAndUserId(
                updateDto.getWorkspaceId(), updateDto.getUserId()
        );

        if(optionalPresence.isEmpty()){
            logger.info("no presence information found for " + updateDto);
            // 현재 세션에 대한 기록이 없음; 해당 워크스페이스에 대한 새로운 상태 정보 기입
            presenceRepository.save(Presence.make(updateDto, sessionId));
        }
        else{
            logger.info("update present information for " + updateDto);
            // 해당 유저의 상태 정보 업데이트 (해당 유저의 세션이 재연결된 경우 상태 업데이트를 하지 않음)
            Presence presence = optionalPresence.get();
            if(presence.getSessions().contains(sessionId)
                && (UserStatus.toEnum(updateDto.getUserStatus()) != UserStatus.CONNECT)){
                presenceRepository.update(updateDto, sessionId, UpdateType.UPDATE_STATUS);
            }
            else{
                // 현재 세션 정보가 없다면 추가
                presenceRepository.update(updateDto, sessionId, UpdateType.ADD_SESSION);
            }
        }
    }
    
    // session id를 통해 적절한 엔티티를 역추산해야 하기 때문에 async 사용 불가
    public Optional<Presence.UpdateDto> deleteOrUpdate(String sessionId){
        Optional<Presence> optionalPresence = presenceRepository.findBySessionId(sessionId);
        
        if(optionalPresence.isPresent()){
            Presence presence = optionalPresence.get();
            if(presence.getSessions().size() == 1){
                // 현재 접속한 세션이 해당 유저가 접속한 유일한 세션이면 프리젠스 정보를 삭제
                presenceRepository.deleteBySessionId(sessionId);
            }
            else{
                presenceRepository.update(presence.export(), sessionId, UpdateType.DELETE_SESSION);
            }
            
            return Optional.ofNullable(
                Presence.UpdateDto.builder()
                    .workspaceId(presence.getWorkspaceId())
                    .userId(presence.getUserId())
                    .userStatus(UserStatus.OFFLINE.toString())
                    .build()
            );
        }
        return Optional.empty();
    }
}
