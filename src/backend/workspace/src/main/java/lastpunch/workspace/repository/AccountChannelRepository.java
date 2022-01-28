package lastpunch.workspace.repository;

import lastpunch.workspace.entity.AccountChannel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface AccountChannelRepository extends JpaRepository<AccountChannel, Long>{
    @Query(
        value = "INSERT INTO accountchannel (accountid, channelid, roleid) "
            + "VALUES (:accountId, :channelId, :roleId)",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    void add(Long accountId, Long channelId, Long roleId);

    @Query(
            value = "UPDATE accountchannel SET roleid=:roleId "
                    + "WHERE accountid=:accountId AND channelid=:channelId",
            nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    Integer edit(Long accountId, Long channelId, Long roleId);

    @Query(
            value = "DELETE FROM accountchannel "
                    + "WHERE accountid=:accountId AND channelid=:channelId",
            nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    Integer delete(Long accountId, Long channelId);
}
