package lastpunch.workspace.repository.channel;

import java.util.List;

import com.querydsl.jpa.impl.JPAQueryFactory;
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
                        account.status, account.settings, account.createdt, account.modifydt
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
}
