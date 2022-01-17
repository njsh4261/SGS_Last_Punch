// original source code work by Jisoo Kim
package lastpunch.workspace.entity;

import java.util.List;

import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

import lastpunch.workspace.common.converter.AccountStatusConverter;
import lastpunch.workspace.dto.AccountExportDto;

@Entity
@Table(name="account")
@Getter
@Setter
@Builder
@AllArgsConstructor
@RequiredArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Account{
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(length = 254, unique = true)
    private String email;
    
    @NotNull
    @Column(columnDefinition = "char(60)")
    private String password;
    
    @Column(length = 30)
    private String name;
    
    private String displayname;
    private String description;
    private String phone;
    private String country;
    private String language;
    
    @Column(columnDefinition = "tinyint")
    private Integer settings;
    
    @Convert(converter = AccountStatusConverter.class)
    @Column(columnDefinition = "tinyint")
    private String status;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdt;
    
    @LastModifiedDate
    private LocalDateTime modifydt;
    
    @OneToMany(mappedBy = "account", orphanRemoval = true)
    List<AccountWorkspace> workspaces;
    
    @OneToMany(mappedBy = "account", orphanRemoval = true)
    List<AccountChannel> channels;
    
    public AccountExportDto export(){
        return AccountExportDto.builder()
            .id(id)
            .email(email)
            .name(name)
            .displayname(displayname)
            .description(description)
            .phone(phone)
            .country(country)
            .language(language)
            .settings(settings)
            .status(status)
            .createdt(createdt)
            .modifydt(modifydt)
            .build();
    }
}
