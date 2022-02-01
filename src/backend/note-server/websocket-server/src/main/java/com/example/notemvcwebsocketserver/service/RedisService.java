package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

@Service
public class RedisService {
    @Autowired
    private StringRedisTemplate redisTemplate;
    ObjectMapper mapper = new ObjectMapper();
    
    public void insertHash(String key, String sessionId, User user){
        try {
            HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
            hashOperations.put("Connection: " + key, sessionId, mapper.writeValueAsString(user));
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public void removeHash(String key, String sessionId){
        try {
            HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
            hashOperations.delete("Connection: " + key, sessionId);
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public List<String>  getHashList(String key){
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
        List<String> values = new ArrayList<>(hashOperations.entries("Connection: " +key).values());
        System.out.println("values = " + values);
        return values;
    }
    
    public String getHashData(String key, String sessionId){
        HashOperations<String, String, String> hashOperations = redisTemplate.opsForHash();
        return hashOperations.get("Connection: " +key, sessionId);
    }
    
//    public void insertList(String key, User user){
//        try {
//            ListOperations<String, String> listOperations = redisTemplate.opsForList();
//            listOperations.rightPush("Connection: " + key, mapper.writeValueAsString(user));
//        }
//        catch(Exception e){
//            System.out.println("e = " + e);
//        }
//    }
//
//    public void removeList(String key, User user){
//        try {
//        ListOperations<String, String> listOperations = redisTemplate.opsForList();
//        listOperations.remove("Connection: "+ key, 1, mapper.writeValueAsString(user));
//        }
//        catch(Exception e){
//            System.out.println("e = " + e);
//        }
//    }
//
//    public List<String>  getList(String key){
//        ListOperations<String, String> listOperations = redisTemplate.opsForList();
//        return listOperations.range("Connection: "+ key,0,-1);
//    }
    
    public String getData(String key) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        String value = valueOperations.get(key);
        return value;
    }
    
    public void setData(String key, String value, long duration) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(key, value, duration, TimeUnit.MILLISECONDS);
    }
    
    public void setNullData(String key) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(key, "");
    }
    
    
    public void setData(String key, User user){
        try {
            ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
            valueOperations.set(key, mapper.writeValueAsString(user));
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public void setSessionData(String sessionId, String noteId ){
        try {
            ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
            valueOperations.set(sessionId, noteId);
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public void removeSessionData(String sessionId){
        try {
            redisTemplate.delete(sessionId);
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }

    public void deleteData(String key) {
        redisTemplate.delete(key);
    }
}

