package lastpunch.workspace.repository.workspace;

import static lastpunch.workspace.entity.QAccount.account;
import static lastpunch.workspace.entity.QAccountWorkspace.accountWorkspace;
import static lastpunch.workspace.entity.QChannel.channel;
import static lastpunch.workspace.entity.QWorkspace.workspace;

import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import javax.persistence.EntityManager;

import lastpunch.workspace.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public class WorkspaceRepositoryImpl implements WorkspaceRepositoryCustom{
    private final JPAQueryFactory jpaQueryFactory;

    @Autowired
    public WorkspaceRepositoryImpl(EntityManager entityManager) {
        this.jpaQueryFactory = new JPAQueryFactory(entityManager);
    }

    @Override
    public Page<Workspace.ExportDto> getListWithUserId(Long id, Pageable pageable){
        List<Workspace.ExportDto> results = jpaQueryFactory
                .select(new QWorkspace_ExportDto(
                    workspace.id, workspace.name, workspace.description,
                    workspace.settings, workspace.createdt, workspace.modifydt
                ))
                .from(workspace)
                .join(workspace.accounts, accountWorkspace)
                .where(
                    workspace.accounts.contains(accountWorkspace),
                    accountWorkspace.account.id.eq(id)
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();
        
        long count = jpaQueryFactory.select(workspace)
                .from(workspace)
                .join(workspace.accounts, accountWorkspace)
                .where(
                        workspace.accounts.contains(accountWorkspace),
                        accountWorkspace.account.id.eq(id)
                )
                .fetch().size();

        return new PageImpl<>(results, pageable, count);
    }

    @Override
    public List<Account.ExportSimpleDto> getAllMembers(Long id) {
        return jpaQueryFactory.select(
                    new QAccount_ExportSimpleDto(account.id, account.name)
                )
                .from(account)
                .join(account.workspaces, accountWorkspace)
                .where(
                        account.workspaces.contains(accountWorkspace),
                        accountWorkspace.workspace.id.eq(id)
                )
                .fetch();
    }

    @Override
    public Page<Account.ExportDto> getMembersPaging(Long id, Pageable pageable){
        List<Account.ExportDto> results = jpaQueryFactory
                .select(new QAccount_ExportDto(
                        account.id, account.email, account.name,
                        account.description, account.phone, account.country, account.language,
                        account.settings, account.createdt, account.modifydt
                ))
                .from(account)
                .join(account.workspaces, accountWorkspace)
                .where(
                        account.workspaces.contains(accountWorkspace),
                        accountWorkspace.workspace.id.eq(id)
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        long count = jpaQueryFactory.select(account)
                .from(account)
                .join(account.workspaces, accountWorkspace)
                .where(
                        account.workspaces.contains(accountWorkspace),
                        accountWorkspace.workspace.id.eq(id)
                )
                .fetch().size();

        return new PageImpl<>(results, pageable, count);
    }

    @Override
    public Page<Channel.ExportDto> getChannelsPaging(Long id, Pageable pageable){
        List<Channel.ExportDto> results = jpaQueryFactory
                .select(new QChannel_ExportDto(
                        channel.id, channel.workspace, channel.name, channel.topic,
                        channel.description, channel.settings, channel.createdt, channel.modifydt
                ))
                .from(channel)
                .join(channel.workspace, workspace)
                .where(
                        channel.workspace.eq(workspace),
                        workspace.id.eq(id)
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        long count = jpaQueryFactory.select(channel)
                .from(channel)
                .join(channel.workspace, workspace)
                .where(
                        channel.workspace.eq(workspace),
                        workspace.id.eq(id)
                )
                .fetch().size();

        return new PageImpl<>(results, pageable, count);
    }
}
