package lastpunch.workspace.entity;

import com.querydsl.core.annotations.QueryProjection;
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
    public static class CreateDto{
        private String workspaceName;
        private String workspaceDescription;
        private String channelName;
        private String channelTopic;
        private String channelDescription;

        public Workspace toWorkspaceEntity(){
            return Workspace.builder()
                    .name(workspaceName)
                    .description(workspaceDescription)
                    .settings(0)
                    .status(0)
                    .createdt(LocalDateTime.now())
                    .modifydt(LocalDateTime.now())
                    .build();
        }

        public Channel toChannelEntity(Workspace workspace, Account account){
            return Channel.builder()
                    .workspace(workspace)
                    .account(account)
                    .name(channelName)
                    .topic(channelTopic)
                    .description(channelDescription)
                    .settings(0)
                    .status(0)
                    .createdt(LocalDateTime.now())
                    .modifydt(LocalDateTime.now())
                    .build();
        }
    }
    
    @Getter
    public static class EditDto {
        private String name;
        private String description;
        private Integer settings;
        private Integer status; // TODO: converter 문제 해결 시 String으로
        
        public Workspace toEntity(Workspace workspace){
            workspace.setName(name);
            workspace.setDescription(description);
            workspace.setSettings(settings);
            workspace.setStatus(status);
            return workspace;
        }
    }
    
    @Getter
    @Builder
    public static class ExportDto{
        private Long id;
        private String name;
        private String description;
        private Integer settings;
        //    private String status; // TODO: converter 문제 해결 시 String으로
        private Integer status;
        private LocalDateTime createdt;
        private LocalDateTime modifydt;

        @QueryProjection
        public ExportDto(Long id, String name, String description, Integer settings, Integer status,
                         LocalDateTime createdt, LocalDateTime modifydt) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.settings = settings;
            this.status = status;
            this.createdt = createdt;
            this.modifydt = modifydt;
        }
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
