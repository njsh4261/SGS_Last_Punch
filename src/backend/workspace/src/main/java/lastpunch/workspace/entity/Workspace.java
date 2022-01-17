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
import org.hibernate.annotations.BatchSize;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

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
    @BatchSize(size=5)
    List<AccountWorkspace> accounts;
    
    @Getter
    public static class ImportDto{
        private String name;
        private String description;
        private Integer settings;
        private Integer status; // TODO: converter 문제 해결 시 String으로
    
        public Workspace toEntity(){
            settings = (settings == null) ? 0 : settings;
            status = (status == null) ? 0 : status;
            return Workspace.builder()
                .name(name)
                .description(description)
                .settings(settings)
                .status(status)
                .build();
        }
    
        public Workspace changeValues(Workspace workspace){
            return Workspace.builder()
                .id(workspace.getId())
                .name((name == null) ? workspace.getName() : name)
                .description((description == null) ? workspace.getDescription() : description)
                .settings((settings == null) ? workspace.getSettings() : settings)
                .status((status == null) ? workspace.getStatus() : status)
                .createdt(workspace.getCreatedt())
                .modifydt(workspace.getModifydt())
                .build();
        }
    }
    
    @Getter
    @Builder
    @AllArgsConstructor
    public static class ExportDto{
        private Long id;
        private String name;
        private String description;
        private Integer settings;
        //    private String status; // TODO: converter 문제 해결 시 String으로
        private Integer status;
        private LocalDateTime createdt;
        private LocalDateTime modifydt;
    }
    
    public ExportDto export(){
        return ExportDto.builder()
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
