package lastpunch.workspace.config;

import com.mongodb.client.MongoClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@Configuration
@EnableMongoRepositories(
    basePackages = "lastpunch.workspace.repository.message",
    mongoTemplateRef = "workspaceMongoTemplate")
@EnableMongoAuditing
public class MongoConfig{
    @Bean
    public MongoTemplate workspaceMongoTemplate(MongoClient mongoClient){
        return new MongoTemplate(
            new SimpleMongoClientDatabaseFactory(mongoClient, "lastpunch")
        );
    }
}
