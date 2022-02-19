package lastpunch.workspace.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
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
    private Integer imagenum;
    
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
                    .createdt(LocalDateTime.now())
                    .modifydt(LocalDateTime.now())
                    .build();
        }

        public Channel toChannelEntity(Workspace workspace){
            return Channel.builder()
                    .workspace(workspace)
                    .name(channelName)
                    .topic(channelTopic)
                    .description(channelDescription)
                    .createdt(LocalDateTime.now())
                    .modifydt(LocalDateTime.now())
                    .build();
        }
    }
    
    @Getter
    public static class EditDto {
        private String name;
        private String description;
        private Integer imageNum;
        
        public Workspace toEntity(Workspace workspace){
            if(name != null){
                workspace.setName(name);
            }
            if(description != null){
                workspace.setDescription(description);
            }
            if(imageNum != null){
                workspace.setImagenum(imageNum);
            }
            if((name != null) || (description != null) || (imageNum != null)){
                workspace.setModifydt(LocalDateTime.now());
            }
            return workspace;
        }
    }
    
    @Getter
    @Builder
    public static class ExportDto{
        private Long id;
        private String name;
        private String description;
        private Integer imageNum;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime createDt;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime modifyDt;

        @QueryProjection
        public ExportDto(Long id, String name, String description, Integer imageNum,
                         LocalDateTime createDt, LocalDateTime modifyDt) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.imageNum = imageNum;
            this.createDt = createDt;
            this.modifyDt = modifyDt;
        }
    }
    
    public ExportDto export(){
        return ExportDto.builder()
            .id(id)
            .name(name)
            .description(description)
            .imageNum(imagenum)
            .createDt(createdt)
            .modifyDt(modifydt)
            .build();
    }

    @Getter
    @Builder
    public static class ExportWithOwnerDto{
        private Long id;
        private String name;
        private String description;
        private Integer imageNum;

        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime createDt;

        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime modifyDt;

        private Account.ExportDto owner;
    }

    public ExportWithOwnerDto exportWithOwner(Account.ExportDto account){
        return ExportWithOwnerDto.builder()
                .id(id)
                .name(name)
                .description(description)
                .imageNum(imagenum)
                .createDt(createdt)
                .modifyDt(modifydt)
                .owner(account)
                .build();
    }
}
