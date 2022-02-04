package lastpunch.chat.config;

import lastpunch.chat.common.jwt.JwtProvider;
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
    
    @Autowired
    public StompInterceptor(JwtProvider jwtProvider){
        this.jwtProvider = jwtProvider;
    }
    
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel){
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        if(accessor.getCommand().equals(StompCommand.CONNECT)){
            String accessToken = accessor.getFirstNativeHeader("Authorization");
            if(ObjectUtils.isEmpty(accessToken)){
                throw new NullPointerException();
            }
            jwtProvider.validateToken(accessToken);
        }
        return message;
    }
}
