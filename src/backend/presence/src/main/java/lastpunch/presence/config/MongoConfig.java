package lastpunch.presence.config;

import com.mongodb.client.MongoClient;
import lastpunch.presence.common.PresenceConstant;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@Configuration
@EnableMongoRepositories(
    basePackages = PresenceConstant.MONGO_BASE_PACKAGES,
    mongoTemplateRef = PresenceConstant.MONGO_TEMPLATE_REF)
@EnableMongoAuditing
public class MongoConfig{
    @Bean
    public MongoTemplate presenceMongoTemplate(MongoClient mongoClient){
        return new MongoTemplate(
            new SimpleMongoClientDatabaseFactory(mongoClient, PresenceConstant.MONGO_DB_NAME)
        );
    }
}
