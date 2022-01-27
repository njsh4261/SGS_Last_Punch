package lastpunch.workspace.repository;


import lastpunch.workspace.entity.Account;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long>{
    Page<Account> findByEmailContaining(String email, Pageable pageable);
}
