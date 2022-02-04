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
    private String language;
    private Integer settings;
    @Convert(converter = StatusConverter.class)
    private String status;
    private LocalDateTime createDt;
    private LocalDateTime modifyDt;
    
    public AccountInfo(Account account){
        this.id = account.getId();
        this.email = account.getEmail();
        this.name = account.getName();
        this.description = account.getDescription();
        this.phone = account.getPhone();
        this.country = account.getCountry();
        this.language = account.getLanguage();
        this.settings = account.getSettings();
        this.status = account.getStatus();
        this.createDt = account.getCreateDt();
        this.modifyDt = account.getModifyDt();
    }
}
