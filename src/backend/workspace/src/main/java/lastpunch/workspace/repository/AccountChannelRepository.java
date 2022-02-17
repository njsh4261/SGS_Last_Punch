package lastpunch.workspace.repository;

import java.util.Optional;

import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.entity.AccountChannel.Dto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

// ManyToOne 필드들로 인해 JPARepository 제공 query나 QueryDSL를 사용하기 어려움
// Native query를 통해 검색
@Repository
public interface AccountChannelRepository extends JpaRepository<AccountChannel, Long> {
    // (accountId, channelId) tuple은 unique; List가 아닌 Single Item으로 결과를 받음
    @Query(
        value = "SELECT accountId, channelId, roleId FROM accountchannel "
            + "WHERE accountId = :accountId AND channelId = :channelId",
        nativeQuery = true
    )
    Optional<Dto> get(Long accountId, Long channelId);
    
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
