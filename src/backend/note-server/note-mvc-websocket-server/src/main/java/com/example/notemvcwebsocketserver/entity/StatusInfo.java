package com.example.notemvcwebsocketserver.entity;

import java.util.List;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StatusInfo {
    private String ownerId;
    private String ownerName;
    private List<String> userList;
}
