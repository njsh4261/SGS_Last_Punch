package lastpunch.workspace;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
//@EnableEurekaClient
@SpringBootApplication
public class WorkspaceApplication {
	public static void main(String[] args) {
		SpringApplication.run(WorkspaceApplication.class, args);
	}
}
