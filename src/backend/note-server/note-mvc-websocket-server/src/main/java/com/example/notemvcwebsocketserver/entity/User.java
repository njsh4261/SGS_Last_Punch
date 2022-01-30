package com.example.notemvcwebsocketserver.entity;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class User {
    private Long id;
    private String name;
}
