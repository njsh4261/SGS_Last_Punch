package lastpunch.notewebsocketserver.config;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.HandlerMapping;
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping;


@Configuration
public class WebSocketConfig {
    
    @Autowired
    private ReactiveWebSocketHandler handler;
    
    @Bean
    public HandlerMapping handlerMapping(){
        Map<String, ReactiveWebSocketHandler> handlerMap = Map.of(
            "/uppercase", handler
        );
        return new SimpleUrlHandlerMapping(handlerMap, 1);
    }
    
}