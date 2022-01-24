package lastpunch.notewebsocketserver.config;

import java.util.HashMap;
import java.util.Map;
import lastpunch.notewebsocketserver.Event;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.HandlerMapping;
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping;
import reactor.core.publisher.Flux;
import reactor.core.publisher.UnicastProcessor;


//@Configuration
//public class WebSocketConfig {
//    @Bean
//    public UnicastProcessor<Event> eventPublisher(){
//        return UnicastProcessor.create();
//    }
//
//    @Bean
//    public Flux<Event> events(UnicastProcessor<Event> eventPublisher) {
//        return eventPublisher
//            .replay(25)
//            .autoConnect();
//    }
//
//
//
//    @Bean
//    public HandlerMapping webSocketMapping(UnicastProcessor<Event> eventPublisher, Flux<Event> events) {
//        Map<String, Object> map = new HashMap<>();
//        map.put("/websocket/chat", new ChatSocketHandler(eventPublisher, events));
//        SimpleUrlHandlerMapping simpleUrlHandlerMapping = new SimpleUrlHandlerMapping();
//        simpleUrlHandlerMapping.setUrlMap(map);
//
//        //Without the order things break :-/
//        simpleUrlHandlerMapping.setOrder(10);
//        return simpleUrlHandlerMapping;
//    }
//
//    @Bean
//    public WebSocketHandlerAdapter handlerAdapter() {
//        return new WebSocketHandlerAdapter();
//    }
//}