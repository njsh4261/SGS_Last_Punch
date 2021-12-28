package LastPunch.searchServer.repository;

import LastPunch.searchServer.document.User;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserEsRepository extends ElasticsearchRepository<User, String> {
    List<User> findByUsernameContains(String name);
}