package lastpunch.authserver.entity;

import lastpunch.authserver.common.StatusConverter;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;


@AllArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
@Builder
@Table(name="account")
@EntityListeners(AuditingEntityListener.class)
@Entity
public class Account {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(length = 254, unique = true)
    private String email;
    
    @NotNull
    @Column(columnDefinition="char(60)")
    private String password;
    
    @Column(length = 30)
    private String name;

    private String description;
    private String phone;
    private String country;
    
    @Convert(converter = StatusConverter.class)
    @Column(columnDefinition = "tinyint")
    private String status;
    
    @Column(columnDefinition = "tinyint")
    private Integer imagenum;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createDt;
    
    @LastModifiedDate
    private LocalDateTime modifyDt;
}
