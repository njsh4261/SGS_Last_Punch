package lastpunch.presence.common;

public class PresenceConstant{
    public static final String ENDPOINT = "/ws/presence";
    public static final String PUBLISH = "/app";
    public static final String SUBSCRIBE = "/topic";
    
    public static final String QUEUE_NAME = "queue";
    public static final String EXCHANGE_NAME = "exchange";
    public static final String ROUTING_KEY_PATTERN = "workspace";
    public static final String ROUTING_KEY_PREFIX = "workspace.";
    public static final String AMQ_TOPIC = "amq.topic";
    
    public static final String MONGO_BASE_PACKAGES = "lastpunch.presence.repository";
    public static final String MONGO_TEMPLATE_REF = "presenceMongoTemplate";
    public static String MONGO_DB_NAME = "lastpunch";
    
    public static String SIMP_SESSION_ID = "simpSessionId";
}
