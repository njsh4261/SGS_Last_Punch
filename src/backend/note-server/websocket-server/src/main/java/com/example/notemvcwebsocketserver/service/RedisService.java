package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class RedisService {
    @Autowired
    private StringRedisTemplate redisTemplate;
    ObjectMapper mapper = new ObjectMapper();
    
    /*
        Redis에서 관리하는 데이터:
        1) 유저 세션 정보: sessionId - noteId
        2) 선점자 정보: noteId - User (or "")
        3) 노트에 연결된 유저 정보: "Connection: {noteId}" - sessionId - User
        서버 재시작할 때마다 Redis 데이터 초기화
     */
    
    // Redis flushall when server restarts
    @PostConstruct
    public void clear() {
        try {
            redisTemplate.execute(new RedisCallback() {
                @Override
                public Object doInRedis(RedisConnection connection) throws DataAccessException {
                    connection.flushAll();
                    return null;
                }
            });
        } catch (Exception e) {
            log.error("Redis flushall failed");
        }
    }
    
    // Methods using Redis Hashes (Note Connections)
    public void insertConnection(String noteId, String sessionId, User user){
        try {
            HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
            hashOperations.put("Connection: " + noteId, sessionId, mapper.writeValueAsString(user));
        }
        catch(JsonProcessingException e){
            log.error("Json Proccessing Exception");
        }
    }
    
    public void removeConnection(String noteId, String sessionId){
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
        hashOperations.delete("Connection: " + noteId, sessionId);
    }
    
    public String getConnection(String noteId, String sessionId){
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
        return hashOperations.get("Connection: " + noteId, sessionId);
    }
    
    public List<String> getConnectionList(String noteId){
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
        return new ArrayList<>(hashOperations.entries("Connection: " + noteId).values());
    }
    
    // Methods for Redis Key-Value pairs ( Session info, Lock info )
    public void setUser(String noteId, User user){
        try {
            ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
            valueOperations.set(noteId, mapper.writeValueAsString(user));
        }
        catch(JsonProcessingException e){
            log.error("Json Proccessing Exception");
        }
    }
    
    public void setSessionData(String sessionId, String noteId){
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(sessionId, noteId);
    }
    
    public void setLockNull(String noteId) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(noteId, "");
    }
    
    public void deleteSessionData(String sessionId){
        redisTemplate.delete(sessionId);
    }
    
    // General Methods
    public String getData(String key) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        return valueOperations.get(key);
    }

    public void deleteData(String key) {
        redisTemplate.delete(key);
    }
}
