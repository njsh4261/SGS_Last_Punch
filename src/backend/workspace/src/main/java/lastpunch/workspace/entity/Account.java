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
    private Integer status;
    
    @Column(columnDefinition = "tinyint")
    private Integer imagenum;
    
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
    @Builder
    public static class ExportDto{
        private Long id;
        private String email;
        private String name;
        private String description;
        private String phone;
        private String country;
        private Integer imageNum;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime createDt;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime modifyDt;

        @QueryProjection
        public ExportDto(Long id, String email, String name, String description,
                         String phone, String country, Integer imageNum,
                         LocalDateTime createDt, LocalDateTime modifyDt){
            this.id = id;
            this.email = email;
            this.name = name;
            this.description = description;
            this.phone = phone;
            this.country = country;
            this.imageNum = imageNum;
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
            .imageNum(imagenum)
            .createDt(createdt)
            .modifyDt(modifydt)
            .build();
    }

    @Getter
    @Setter
    public static class ExportSimpleDto{
        private Long id;
        private String name;
        private String email;
        private Message lastMessage;

        @QueryProjection
        public ExportSimpleDto(Long id, String name, String email){
            this.id = id;
            this.name = name;
            this.email = email;
        }
    }
}
