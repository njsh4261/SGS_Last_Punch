package lastpunch.workspace.repository.account;

import static lastpunch.workspace.entity.QAccount.account;

import com.querydsl.core.NonUniqueResultException;
import com.querydsl.jpa.impl.JPAQueryFactory;
import java.util.List;
import javax.persistence.EntityManager;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.entity.Account.ExportDto;
import lastpunch.workspace.entity.QAccount_ExportDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public class AccountRepositoryImpl implements AccountRepositoryCustom{
    private final JPAQueryFactory jpaQueryFactory;
    
    @Autowired
    public AccountRepositoryImpl(EntityManager entityManager){
        this.jpaQueryFactory = new JPAQueryFactory(entityManager);
    }
    
    @Override
    public Page<ExportDto> findByEmail(String email, Pageable pageable, Long id){
        try{
            String requester_email = jpaQueryFactory.select(account.email)
                .from(account)
                .where(account.id.eq(id))
                .fetchOne();
    
            List<ExportDto> results = jpaQueryFactory
                .select(new QAccount_ExportDto(
                    account.id, account.email, account.name,
                    account.description, account.phone, account.country, account.language,
                    account.settings, account.createdt, account.modifydt
                ))
                .from(account)
                .where(
                    account.email.contains(email),
                    account.email.ne(requester_email)
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();
    
            long count = jpaQueryFactory.select(account)
                .from(account)
                .where(
                    account.email.contains(email),
                    account.email.ne(requester_email)
                )
                .fetch().size();
            return new PageImpl<>(results, pageable, count);
        } catch(NonUniqueResultException e){
            throw new BusinessException(StatusCode.INVALID_USERID);
        }
    }
}
