package lastpunch.chat.config;

import lastpunch.chat.common.exception.BusinessException;
import lastpunch.chat.common.exception.StatusCode;
import lastpunch.chat.common.jwt.JwtProvider;
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
    private JwtProvider jwtProvider;
    private Logger logger;
    
    @Autowired
    public StompInterceptor(JwtProvider jwtProvider){
        this.jwtProvider = jwtProvider;
        this.logger = LoggerFactory.getLogger(StompInterceptor.class);
    }
    
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel){
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        if(accessor.getCommand().equals(StompCommand.CONNECT)){
            String accessToken = accessor.getFirstNativeHeader("Authorization");
            if(ObjectUtils.isEmpty(accessToken)){
                logger.info("StompInterceptor: Message is blocked; token does not exist");
                throw new BusinessException(StatusCode.TOKEN_NOT_EXIST);
            }
            if(!jwtProvider.validateToken(accessToken)){
                logger.info("StompInterceptor: Message is blocked; token is not valid");
                throw new BusinessException(StatusCode.TOKEN_INVALID);
            }
        }
        return message;
    }
}
