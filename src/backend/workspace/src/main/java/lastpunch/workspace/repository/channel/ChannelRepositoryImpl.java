package lastpunch.workspace.repository.channel;

import com.querydsl.core.NonUniqueResultException;
import java.util.List;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.Account.ExportDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import javax.persistence.EntityManager;

import lastpunch.workspace.entity.*;
import static lastpunch.workspace.entity.QAccount.account;
import static lastpunch.workspace.entity.QChannel.channel;
import static lastpunch.workspace.entity.QAccountChannel.accountChannel;

@Repository
public class ChannelRepositoryImpl implements ChannelRepositoryCustom{
    private final JPAQueryFactory jpaQueryFactory;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    public ChannelRepositoryImpl(EntityManager entityManager){
        this.jpaQueryFactory = new JPAQueryFactory(entityManager);
    }

    @Override
    public Page<Account.ExportDto> getMembers(Long id, Pageable pageable) {
        List<Account.ExportDto> results = jpaQueryFactory
                .select(new QAccount_ExportDto(
                        account.id, account.email, account.name,
                        account.description, account.phone, account.country, account.language,
                        account.settings, account.createdt, account.modifydt
                ))
                .from(account)
                .join(account.channels, accountChannel)
                .where(
                        account.channels.contains(accountChannel),
                        accountChannel.channel.id.eq(id)
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();
        
        logger.info(results.toString());

        long count = jpaQueryFactory.select(account)
                .from(account)
                .join(account.channels, accountChannel)
                .where(
                        account.channels.contains(accountChannel),
                        accountChannel.channel.id.eq(id)
                )
                .fetch().size();

        return new PageImpl<>(results, pageable, count);
    }
    
    @Override
    public ExportDto getOwnerOfChannel(Long channelId){
        try{
            List<ExportDto> owner = jpaQueryFactory
                .select(new QAccount_ExportDto(
                    account.id, account.email, account.name,
                    account.description, account.phone, account.country, account.language,
                    account.settings, account.createdt, account.modifydt
                ))
                .from(account)
                .join(accountChannel).on(account.id.eq(accountChannel.account.id))
                .where(
                    accountChannel.channel.id.eq(channelId),
                    accountChannel.role.id.eq(RoleType.OWNER.getId())
                )
                .fetch();
            if(owner.size() != 1){
                throw new BusinessException(StatusCode.CHANNEL_OWNER_SET_ERROR);
            }
            return owner.get(0);
        } catch(NonUniqueResultException e){
            throw new BusinessException(StatusCode.CHANNEL_OWNER_SET_ERROR);
        }
    }

    @Override
    public Page<Channel.ExportSimpleDtoImpl> findByName(Long workspaceId, String name, Pageable pageable) {
        List<Channel.ExportSimpleDtoImpl> results = jpaQueryFactory
                .select(new QChannel_ExportSimpleDtoImpl(
                        channel.id, channel.name
                ))
                .from(channel)
                .where(
                        channel.workspace.id.eq(workspaceId),
                        channel.name.contains(name)
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        long count = jpaQueryFactory.select(channel)
                .from(channel)
                .where(
                        channel.workspace.id.eq(workspaceId),
                        channel.name.contains(name)
                )
                .fetch().size();

        return new PageImpl<>(results, pageable, count);
    }
}
