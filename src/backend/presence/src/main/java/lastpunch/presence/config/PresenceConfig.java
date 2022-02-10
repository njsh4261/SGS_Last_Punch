package lastpunch.presence.config;

import lastpunch.presence.common.PresenceConstant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class PresenceConfig implements WebSocketMessageBrokerConfigurer{
    private StompInterceptor stompInterceptor;
    
    @Value("${rabbitmq-stomp.host}")
    private String stompHost;
    
    @Value("${rabbitmq-stomp.port}")
    private int stompPort;
    
    @Value("${rabbitmq-stomp.username}")
    private String username;
    
    @Value("${rabbitmq-stomp.password}")
    private String password;
    
    @Autowired
    public PresenceConfig(StompInterceptor stompInterceptor){
        this.stompInterceptor = stompInterceptor;
    }
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry){
        registry.addEndpoint(PresenceConstant.ENDPOINT)
            .setAllowedOriginPatterns("*")
            .withSockJS()
            .setSupressCors(true);
    }
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry){
        registry.setApplicationDestinationPrefixes(PresenceConstant.PUBLISH);
        registry.enableStompBrokerRelay(PresenceConstant.SUBSCRIBE)
            .setRelayHost(stompHost)
            .setRelayPort(stompPort)
            .setClientLogin(username)
            .setClientPasscode(password);
    }
    
    @Override
    public void configureClientInboundChannel(ChannelRegistration registration){
        registration.interceptors(stompInterceptor);
    }
}
