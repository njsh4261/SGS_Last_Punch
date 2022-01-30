package com.example.notemvcwebsocketserver.service;

import com.example.notemvcwebsocketserver.entity.Connection;
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
    
    public void insertList(String key, Connection connection){
        try {
            ListOperations<String, String> listOperations = redisTemplate.opsForList();
            listOperations.rightPush("Connection: " + key, mapper.writeValueAsString(connection));
        }
        catch(Exception e){
            System.out.println("e = " + e);
        }
    }
    
    public void removeList(String key, Connection connection){
        try {
        ListOperations<String, String> listOperations = redisTemplate.opsForList();
        listOperations.remove("Connection: "+ key, 1, mapper.writeValueAsString(connection));
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
        return valueOperations.get(key);
    }
    
    public void setData(String key, String value, long duration) {
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(key, value, duration, TimeUnit.MILLISECONDS);
    }
    
    public void setData(String key, String value){
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        valueOperations.set(key, value);
    }

    public void deleteData(String key) {
        redisTemplate.delete(key);
    }
}

