package lastpunch.chat.common;

public class ChatConstant{
    public static final String ENDPOINT = "/ws/chat";
    public static final String PUBLISH = "/app";
    public static final String SUBSCRIBE = "/topic";
    
    public static final String QUEUE_NAME = "queue";
    public static final String EXCHANGE_NAME = "exchange";
    public static final String ROUTING_KEY_PATTERN = "channel";
    public static final String ROUTING_KEY_PREFIX = "channel.";
    public static final String AMQ_TOPIC = "amq.topic";
    
    public static final Long KOR_TIMEZONE = 9L;
}
