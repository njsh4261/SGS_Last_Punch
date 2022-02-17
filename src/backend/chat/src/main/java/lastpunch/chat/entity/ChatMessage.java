package lastpunch.chat.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import lastpunch.chat.common.MessageType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "messages")
@Getter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessage{
    @Id
    private String id;
    
    private String authorId;
    private String channelId;
    private String content;
    private Integer status;
    
    @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
    private LocalDateTime createDt;
    
    @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
    private LocalDateTime modifyDt;
    
    // `POST /chat/recent`를 위한 DTO
    @Getter
    @ToString
    public static class EnterDto{
        private String channelId;
    }
    
    // `POST /chat/old`를 위한 DTO
    @Getter
    public static class GetOlderDto{
        private String channelId;

        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime dateTime;
    }
    
    // 채팅 서버가 클라이언트로부터 메시지를 수신할 때 사용
    @Getter
    @ToString
    public static class ReceiveDto{
        private String authorId;
        private String channelId;
        private MessageType type;
        private String content;
        
        public ChatMessage toEntity(){
            return ChatMessage.builder()
                .authorId(authorId)
                .channelId(channelId)
                .content(content)
                .status(0)
                .createDt(LocalDateTime.now())
                .modifyDt(LocalDateTime.now())
                .build();
        }
        
        public TypingDto toTypingDto(){
            return TypingDto.builder()
                .authorId(authorId)
                .channelId(channelId)
                .type(type.toString())
                .build();
        }
    }
    
    // 채팅 서버가 클라이언트에게 유저의 입력 중 상태를 전달하기 위해 사용
    @Getter
    @Builder
    public static class TypingDto{
        private String authorId;
        private String channelId;
        private String type;
    }
}
