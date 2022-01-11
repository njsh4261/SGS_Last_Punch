package lastpunch.workspace.entity;

import com.sun.istack.NotNull;
import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

@Entity
@Table(name="workspace")
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Workspace{
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    private String name;
    
    private String description;
    
    @Column(columnDefinition="tinyint")
    private Integer settings;
    
    @Column(columnDefinition="tinyint")
    private Integer status;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdDt;
    
    @LastModifiedDate
    private LocalDateTime modifiedDt;
}
