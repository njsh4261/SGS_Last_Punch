package lastpunch.presence.config;

import lastpunch.presence.common.PresenceConstant;
import lastpunch.presence.common.jwt.JwtProvider;
import lastpunch.presence.service.MongoService;
import lastpunch.presence.service.RabbitMQService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;

@Component
public class StompInterceptor implements ChannelInterceptor{
    private final JwtProvider jwtProvider;
    private final RabbitMQService rabbitMQService;
    private final Logger logger;
    
    @Autowired
    public StompInterceptor(JwtProvider jwtProvider, RabbitMQService rabbitMQService){
        this.jwtProvider = jwtProvider;
        this.rabbitMQService = rabbitMQService;
        this.logger = LoggerFactory.getLogger(StompInterceptor.class);
    }
    
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel){
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        StompCommand stompCommand = accessor.getCommand();
        if(stompCommand != null){
            if(stompCommand == StompCommand.CONNECT){
                String accessToken = accessor.getFirstNativeHeader("Authorization");
                if(ObjectUtils.isEmpty(accessToken)){
                    logger.info("StompInterceptor: Message is blocked; token does not exist");
                    return null;
                }
                if(!jwtProvider.validateToken(accessToken)){
                    logger.info("StompInterceptor: Message is blocked; token is not valid");
                    return null;
                }
            }
        }
        return message;
    }
    
    // reference: https://gompangs.tistory.com/entry/Spring-boot-Websocket-connect-disconnect-%EA%B4%80%EB%A0%A8
    @Override
    public void postSend(Message<?> message, MessageChannel channel, boolean sent){
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        StompCommand stompCommand = accessor.getCommand();
        if(stompCommand != null){
            if(stompCommand == StompCommand.DISCONNECT){
                String sessionId = (String) message.getHeaders().getOrDefault(
                    PresenceConstant.SIMP_SESSION_ID, null
                );
                logger.info("Disconnected; sessionId " + sessionId);
                rabbitMQService.deleteUserStatus(sessionId);
            }
        }
    }
}
