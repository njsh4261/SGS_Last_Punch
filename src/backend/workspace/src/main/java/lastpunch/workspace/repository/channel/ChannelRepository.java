package lastpunch.workspace.repository.channel;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import lastpunch.workspace.entity.Channel;

@Repository
public interface ChannelRepository extends JpaRepository<Channel, Long>, ChannelRepositoryCustom{
}
