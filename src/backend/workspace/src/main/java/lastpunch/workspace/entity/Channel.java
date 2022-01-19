package lastpunch.workspace.entity;

import com.querydsl.core.annotations.QueryProjection;
import com.sun.istack.NotNull;
import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.BatchSize;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

@Entity
@Table(name = "channel")
@Getter
@Setter
@Builder
@AllArgsConstructor
@RequiredArgsConstructor
public class Channel{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(targetEntity=Workspace.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "workspaceid")
    private Workspace workspace;
    
    @ManyToOne(targetEntity=Account.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "creatorid")
    private Account account;
    
    @NotNull
    private String name;
    
    private String topic;
    private String description;
    
    @NotNull
    @Column(columnDefinition = "tinyint")
    private Integer settings;
    
    @NotNull
    @Column(columnDefinition = "tinyint")
    private Integer status; // TODO: converter 문제 해결 시 String으로
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdt;
    
    @LastModifiedDate
    private LocalDateTime modifydt;
    
    @OneToMany(mappedBy = "channel", orphanRemoval = true)
    @BatchSize(size=5)
    List<AccountChannel> accounts;
    
    @Getter
    public class CreateDto {
        private Long workspaceId;
        private Long creatorId;
        private String name;
        private String topic;
        private String description;

        public Channel toEntity(Workspace workspace, Account account){
            return Channel.builder()
                .workspace(workspace)
                .account(account)
                .name(name)
                .topic(topic)
                .description(description)
                .settings(0)
                .status(0)
                .createdt(LocalDateTime.now())
                .modifydt(LocalDateTime.now())
                .build();
        }
    }
    
    public class EditDto{
        private String name;
        private String topic;
        private String description;
        private Integer settings;
        private Integer status;
        
        public Channel toEntity(Channel channel){
            channel.setName(name);
            channel.setTopic(topic);
            channel.setDescription(description);
            channel.setSettings(settings);
            channel.setStatus(status);
            return channel;
        }
    }
    
    @Getter
    public class ExportDto{
        private Long id;
        private Workspace.ExportDto workspace;
        private Account.ExportDto creator;
        private String name;
        private String topic;
        private String description;
        private Integer settings;
        private Integer status;
        private LocalDateTime createDt;
        private LocalDateTime modifyDt;

        @QueryProjection
        public ExportDto(Long id, Workspace workspace, Account account, String name, String topic,
                         String description, Integer settings, Integer status,
                         LocalDateTime createDt, LocalDateTime modifyDt) {
            this.id = id;
            this.workspace = workspace.export();
            this.creator = account.export();
            this.name = name;
            this.topic = topic;
            this.description = description;
            this.settings = settings;
            this.status = status;
            this.createDt = createDt;
            this.modifyDt = modifyDt;
        }
    }
    
    public ExportDto export(){
        return new ExportDto(
                id, workspace, account, name, topic, description,
                settings, status, createdt, modifydt
        );
    }
}
