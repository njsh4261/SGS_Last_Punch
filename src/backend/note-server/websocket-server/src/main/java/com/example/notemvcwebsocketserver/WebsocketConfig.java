package com.example.notemvcwebsocketserver;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Configuration
@EnableWebSocketMessageBroker
public class WebsocketConfig implements WebSocketMessageBrokerConfigurer {
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/sub", "/user");
        config.setApplicationDestinationPrefixes("/pub");
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // sockJS 연결 주소 http://localhost:8080/ws/note 사용
        registry.addEndpoint("/ws/note").setAllowedOrigins("http://localhost:3000").withSockJS();
        // 웹소켓 연결 주소 ws://localhost:8080/ws/note 사용
        registry.addEndpoint("/ws/note").setAllowedOrigins("http://localhost:3000");
    }
}