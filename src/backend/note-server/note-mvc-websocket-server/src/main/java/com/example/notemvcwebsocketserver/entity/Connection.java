package com.example.notemvcwebsocketserver.entity;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Connection {
    private String userId;
    private String userName;
}
