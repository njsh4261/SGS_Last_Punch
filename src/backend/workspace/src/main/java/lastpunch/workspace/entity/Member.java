// original source code work by Jisoo Kim

package lastpunch.workspace.entity;

import lastpunch.workspace.common.converter.MemberStatusConverter;
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
@Table(name="member")
@EntityListeners(AuditingEntityListener.class)
@Entity
public class Member {
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
    
    private String displayName;
    private String description;
    private String phone;
    private String country;
    private String language;
    
    @Column(columnDefinition = "tinyint")
    private Integer settings;
    
    @Convert(converter = MemberStatusConverter.class)
    @Column(columnDefinition = "tinyint")
    private String status;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdDt;
    
    @LastModifiedDate
    private LocalDateTime modifiedDt;
}
