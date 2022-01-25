package lastpunch.workspace.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import lastpunch.workspace.entity.Account;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long>{
}
