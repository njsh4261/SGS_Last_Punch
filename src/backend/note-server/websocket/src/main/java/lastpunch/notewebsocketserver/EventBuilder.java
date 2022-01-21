package lastpunch.notewebsocketserver;

import java.util.HashMap;
import java.util.Map;

public class EventBuilder {
    private Event.Type type;
    private PayloadBuilder payloadBuilder = new PayloadBuilder();
    
    public EventBuilder type(Event.Type type) {
        this.type = type;
        return this;
    }
    
    public PayloadBuilder withPayload() {
        return payloadBuilder;
    }
    
    private Event buildEvent(Payload payload) {
        return new Event(type, payload);
    }
    
    protected class PayloadBuilder {
        
        private String alias;
        private Map<String, Object> properties = new HashMap<>();
        
        public PayloadBuilder userAlias(String alias) {
            this.alias = alias;
            return this;
        }
        
        
        public PayloadBuilder user(User user) {
            this.alias = user.getAlias();
            return this;
        }
        
        public PayloadBuilder systemUser() {
            user(User.systemUser());
            return this;
        }
        
        public PayloadBuilder property(String property, Object value) {
            properties.put(property, value);
            return this;
        }
        
        
        public Event build() {
            return buildEvent(new Payload(new User(payloadBuilder.alias), properties));
        }
    }
}