package lastpunch.workspace.repository.channel;

import java.util.List;

import com.querydsl.jpa.impl.JPAQueryFactory;
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

    @Autowired
    public ChannelRepositoryImpl(EntityManager entityManager){
        this.jpaQueryFactory = new JPAQueryFactory(entityManager);
    }

    @Override
    public Page<Account.ExportDto> getMembers(Long id, Pageable pageable) {
        List<Account.ExportDto> results = jpaQueryFactory
                .select(new QAccount_ExportDto(
                        account.id, account.email, account.name, account.displayname, account.description,
                        account.phone, account.country, account.language, account.settings, account.status,
                        account.createdt, account.modifydt
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
