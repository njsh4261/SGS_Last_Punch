// original source code work by Jisoo Kim
package lastpunch.workspace.entity;

import com.querydsl.core.annotations.QueryProjection;
import java.util.List;

import lombok.*;
import org.hibernate.annotations.BatchSize;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

import lastpunch.workspace.common.converter.AccountStatusConverter;

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
    @BatchSize(size=5)
    List<AccountWorkspace> workspaces;
    
    @OneToMany(mappedBy = "account", orphanRemoval = true)
    @BatchSize(size=5)
    List<AccountChannel> channels;
    
    @Getter
    public static class FindDto{
        private String email;
    }
    
    @Getter
    @Setter
    @Builder
    public static class ExportDto{
        private Long id;
        private String email;
        private String name;
        private String displayname;
        private String description;
        private String phone;
        private String country;
        private String language;
        private Integer settings;
        private String status;
        private LocalDateTime createDt;
        private LocalDateTime modifyDt;
        private Message lastMessage;

        @QueryProjection
        public ExportDto(Long id, String email, String name, String displayname, String description,
                         String phone, String country, String language, Integer settings, String status,
                         LocalDateTime createDt, LocalDateTime modifyDt) {
            this.id = id;
            this.email = email;
            this.name = name;
            this.displayname = displayname;
            this.description = description;
            this.phone = phone;
            this.country = country;
            this.language = language;
            this.settings = settings;
            this.status = status;
            this.createDt = createDt;
            this.modifyDt = modifyDt;
        }
    }
    
    public ExportDto export(){
        return ExportDto.builder()
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
            .createDt(createdt)
            .modifyDt(modifydt)
            .build();
    }
}
