package lastpunch.workspace.entity;

import com.sun.istack.NotNull;
import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.*;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import lastpunch.workspace.dto.WorkspaceExportDto;

@Entity
@Table(name="workspace")
@Getter
@Setter
@Builder
@AllArgsConstructor
@RequiredArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Workspace{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    private String name;
    
    private String description;
    
    @NotNull
    @Column(columnDefinition = "tinyint")
    private Integer settings;
    
    @NotNull
//    @Convert(converter = WorkspaceStatusConverter.class)
    @Column(columnDefinition = "tinyint")
    private Integer status; // TODO: converter 문제 해결 시 String으로
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdt;
    
    @LastModifiedDate
    private LocalDateTime modifydt;
    
    @OneToMany(mappedBy = "workspace", orphanRemoval = true)
    List<AccountWorkspace> accounts;
    
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
