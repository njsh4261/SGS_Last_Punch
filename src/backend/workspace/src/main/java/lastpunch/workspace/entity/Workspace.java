package lastpunch.workspace.entity;

import com.sun.istack.NotNull;
import java.time.LocalDateTime;
import java.util.Set;
import javax.persistence.*;

import lastpunch.workspace.common.converter.WorkspaceStatusConverter;
import lastpunch.workspace.dto.AccountExportDto;
import lastpunch.workspace.dto.WorkspaceExportDto;
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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    private String name;
    
    private String description;
    
    @Column(columnDefinition = "tinyint")
    private Integer settings;

    @Convert(converter = WorkspaceStatusConverter.class)
    @Column(columnDefinition = "tinyint")
    private String status;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdt;
    
    @LastModifiedDate
    private LocalDateTime modifydt;
    
    @OneToMany(mappedBy = "workspace")
    Set<AccountWorkspace> accounts;
    
    public WorkspaceExportDto export(){
        return WorkspaceExportDto.builder()
            .id(id)
            .name(name)
            .description(description)
            .settings(settings)
            .status(status)
            .createdt(createdt)
            .modifydt(modifydt)
            .build();
    }
}
