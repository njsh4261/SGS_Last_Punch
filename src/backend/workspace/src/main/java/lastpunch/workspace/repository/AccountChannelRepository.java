package lastpunch.workspace.repository;

import lastpunch.workspace.entity.AccountChannel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface AccountChannelRepository extends JpaRepository<AccountChannel, Long>{
    @Query(
        value = "INSERT INTO accountchannel (accountId, channelId) "
            + "VALUES (:accountId, :channelId)",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    void save(Long accountId, Long channelId);
    
    @Query(
        value = "DELETE FROM accountchannel "
            + "WHERE accountId = :accountId AND channelId = :channelId",
        nativeQuery = true
    )
    @Modifying(clearAutomatically = true)
    @Transactional
    void delete(Long accountId, Long channelId);
}
