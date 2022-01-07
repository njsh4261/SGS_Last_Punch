package LastPunch.searchServer.repository;

import LastPunch.searchServer.dto.ChannelDto;
import LastPunch.searchServer.dto.UserDto;
import java.nio.channels.Channel;
import java.util.List;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChannelEsRepository extends ElasticsearchRepository<ChannelDto, String>{
    List<ChannelDto> findByNameContains(String name);
}