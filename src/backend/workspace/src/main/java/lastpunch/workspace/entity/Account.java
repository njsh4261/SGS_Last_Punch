// original source code work by Jisoo Kim
package lastpunch.workspace.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.querydsl.core.annotations.QueryProjection;
import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.BatchSize;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

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
    
    private String description;
    private String phone;
    private String country;
    private String language;
    
    @Column(columnDefinition = "tinyint")
    private Integer settings;

    @Column(columnDefinition = "tinyint")
    private Integer status;
    
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
    @AllArgsConstructor
    public static class ExportDto{
        private Long id;
        private String email;
        private String name;
        private String description;
        private String phone;
        private String country;
        private String language;
        private Integer settings;
        private Integer status;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime createDt;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime modifyDt;
        
        private Message lastMessage;

        @QueryProjection
        public ExportDto(Long id, String email, String name, String description, String phone,
                         String country, String language, Integer settings, Integer status,
                         LocalDateTime createDt, LocalDateTime modifyDt) {
            this.id = id;
            this.email = email;
            this.name = name;
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
