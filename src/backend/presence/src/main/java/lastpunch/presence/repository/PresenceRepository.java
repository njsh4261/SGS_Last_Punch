package lastpunch.presence.repository;

import java.util.List;
import java.util.Map;
import lastpunch.presence.dto.PresenceDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class PresenceRepository{
    private final RedisTemplate<String, Object> redisTemplate;
    
    @Autowired
    public PresenceRepository(RedisTemplate<String, Object> redisTemplate){
        this.redisTemplate = redisTemplate;
    }
    
    public void save(PresenceDto presenceDto){
        redisTemplate.opsForHash().put(
            presenceDto.getWorkspaceId(), presenceDto.getUserId(), presenceDto.getStatus()
        );
    }
    
    public Map<String, String> getWorkspacePresence(String workspaceId){
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
        return hashOperations.entries(workspaceId);
    }
}
