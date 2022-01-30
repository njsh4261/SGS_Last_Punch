package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

@Service
public class RedisService {
    @Autowired
    private StringRedisTemplate redisTemplate;
    ObjectMapper mapper = new ObjectMapper();
    
    public void insertList(String key, User user){
        try {
            ListOperations<String, String> listOperations = redisTemplate.opsForList();
            listOperations.rightPush("Connection: " + key, mapper.writeValueAsString(user));
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public void removeList(String key, User user){
        try {
        ListOperations<String, String> listOperations = redisTemplate.opsForList();
        listOperations.remove("Connection: "+ key, 1, mapper.writeValueAsString(user));
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public List<String>  getList(String key){
        ListOperations<String, String> listOperations = redisTemplate.opsForList();
        return listOperations.range("Connection: "+ key,0,-1);
    }
    
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

    public void deleteData(String key) {
        redisTemplate.delete(key);
    }
}

