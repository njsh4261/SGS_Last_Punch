package lastpunch.authserver.dto;

import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import lastpunch.authserver.common.StatusConverter;
import lastpunch.authserver.entity.Account;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

@Data
public class AccountInfo {
    private Long id;
    private String email;
    private String name;
    private String description;
    private String phone;
    private String country;
    @Convert(converter = StatusConverter.class)
    private String status;
    private final Integer imageNum;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
    
    public AccountInfo(Account account){
        this.id = account.getId();
        this.email = account.getEmail();
        this.name = account.getName();
        this.description = account.getDescription();
        this.phone = account.getPhone();
        this.country = account.getCountry();
        this.status = account.getStatus();
        this.imageNum = account.getImagenum();
        this.createDt = account.getCreateDt();
        this.modifyDt = account.getModifyDt();
    }
}
