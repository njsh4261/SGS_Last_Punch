package lastpunch.workspace.repository.channel;

import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Channel.ImportDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface ChannelRepository extends JpaRepository<Channel, Long>{
//    @Query(
//        value = "INSERT INTO channel "
//            + "(workspaceId, creatorId, name, topic, description, settings, status) "
//            + "VALUES (:workspaceId, :creatorId, :name, :topic, :description, :settings, :status)",
//        nativeQuery = true
//    )
//    @Modifying(clearAutomatically = true)
//    @Transactional
//    void create(ImportDto channelImportDto);
    
//    @Query(
//        value = "INSERT INTO channel "
//            + "(workspaceId, creatorId, name, topic, description, settings, status) "
//            + "VALUES ("
//            + ":channelCreateDto.getWorkspaceId, "
//            + ":channelCreateDto.getCreatorId, "
//            + ":channelCreateDto.getName, "
//            + ":channelCreateDto.getTopic, "
//            + ":channelCreateDto.getDescription, "
//            + ":channelCreateDto.getSettings, "
//            + ":channelCreateDto.getStatus"
//            + ")",
//        nativeQuery = true
//    )
//    @Modifying(clearAutomatically = true)
//    @Transactional
//    void edit(ChannelEditDto channelEditDto);
}
