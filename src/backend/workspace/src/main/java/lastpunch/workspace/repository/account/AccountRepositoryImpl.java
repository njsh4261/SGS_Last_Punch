package lastpunch.workspace.repository.account;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import lastpunch.workspace.entity.Account;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import static lastpunch.workspace.entity.QAccount.account;
import static lastpunch.workspace.entity.QAccountWorkspace.accountWorkspace;

@Repository
@RequiredArgsConstructor
public class AccountRepositoryImpl implements AccountRepositoryCustom{
    private JPAQueryFactory jpaQueryFactory;
    
    @Override
    public Page<Account.ExportDto> getMembersOfWorkspace(Long workspaceId, Pageable pageable){
        List<Account.ExportDto> content = jpaQueryFactory.select(
                Projections.constructor(Account.ExportDto.class,
                    account.id, account.email, account.name, account.displayname,
                    account.description, account.phone, account.country, account.language,
                    account.settings, account.status, account.createdt, account.modifydt
                )
            )
            .from(account)
            .join(account.workspaces, accountWorkspace)
            .where(accountWorkspace.workspace.id.eq(workspaceId))
            .offset(pageable.getOffset())
            .limit(pageable.getPageSize())
            .fetch();
        return new PageImpl<>(content, pageable, content.size());
    }
    
    @Override
    public Page<Account.ExportDto> getMembersOfChannel(Long channelId, Pageable pageable){
        return null;
    }
}
