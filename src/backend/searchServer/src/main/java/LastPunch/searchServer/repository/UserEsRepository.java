package LastPunch.searchServer.repository;

import LastPunch.searchServer.dto.UserDto;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserEsRepository extends ElasticsearchRepository<UserDto, String> {
    List<UserDto> findByNameContains(String name);
}