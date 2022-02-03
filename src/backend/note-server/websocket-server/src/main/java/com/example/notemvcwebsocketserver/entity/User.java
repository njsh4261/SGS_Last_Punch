package com.example.notemvcwebsocketserver.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class User {
    private Long id;
    private String name;
    
    @JsonCreator
    public User(@JsonProperty("id") Long id, @JsonProperty("name") String name){
        this.id = id;
        this.name = name;
    }
}
