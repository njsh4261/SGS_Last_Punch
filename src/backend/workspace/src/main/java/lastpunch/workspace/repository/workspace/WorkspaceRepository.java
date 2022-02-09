package lastpunch.workspace.repository.workspace;

import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WorkspaceRepository extends JpaRepository<Workspace, Long>, WorkspaceRepositoryCustom{
    @Query(
            value = "SELECT c.id as id, c.name as name " +
                    "FROM channel AS c " +
                    "   INNER JOIN (" +
                    "       SELECT ac.channelId as channelId " +
                    "       FROM (SELECT id, name FROM account) AS a " +
                    "           INNER JOIN ( " +
                    "               SELECT * FROM accountchannel WHERE accountId = :userId " +
                    "           ) AS ac" +
                    "       WHERE a.id = ac.accountId " +
                    "   ) AS ac2 " +
                    "WHERE c.id = ac2.channelId AND c.workspaceId = :workspaceId",
            nativeQuery = true
    )
    List<Channel.ExportSimpleDto> getAllChannels(Long workspaceId, Long userId);
}
