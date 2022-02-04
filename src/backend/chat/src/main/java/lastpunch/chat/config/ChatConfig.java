package lastpunch.chat.config;

import lastpunch.chat.common.ChatConstant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class ChatConfig implements WebSocketMessageBrokerConfigurer{
    private StompInterceptor stompInterceptor;
    
    @Autowired
    public ChatConfig(StompInterceptor stompInterceptor){
        this.stompInterceptor = stompInterceptor;
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint(ChatConstant.ENDPOINT)
            .setAllowedOrigins("http://localhost:3000")
            .withSockJS()
            .setSupressCors(true);
    }
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.setApplicationDestinationPrefixes(ChatConstant.PUBLISH);
        registry.enableStompBrokerRelay(ChatConstant.SUBSCRIBE);
    }
    
    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(stompInterceptor);
    }
}
