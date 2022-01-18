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
    public static class ImportDto{
        private Long workspaceId;
        private Long creatorId;
        private String name;
        private String topic;
        private String description;
        private Integer settings;
        private Integer status;

        public boolean isEmpty(){
            return (workspaceId == null) && (creatorId == null) && (name == null) && (topic == null)
                    && (description == null) && (settings == null) && (status == null);
        }
    }
    
    @Getter
    public static class ExportDto{
        private Long id;
        private Long workspaceId; // TODO: 필요에 따라 WorkspaceExportDto로 변경
        private Account.ExportDto creator; // TODO: 필요에 따라 더 적은 정보만을 전달
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
            this.workspaceId = workspace.getId();
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
