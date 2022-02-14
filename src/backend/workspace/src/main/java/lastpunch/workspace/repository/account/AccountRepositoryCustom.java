package lastpunch.workspace.repository.account;

import lastpunch.workspace.entity.Account.ExportDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface AccountRepositoryCustom{
    Page<ExportDto> findByEmail(String email, Pageable pageable, Long id);
}
