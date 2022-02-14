package lastpunch.workspace.repository.channel;

import lastpunch.workspace.entity.Channel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChannelRepository extends JpaRepository<Channel, Long>, ChannelRepositoryCustom{
}
