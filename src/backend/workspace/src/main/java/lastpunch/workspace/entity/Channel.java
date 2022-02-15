package lastpunch.workspace.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
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
import org.springframework.data.jpa.repository.Query;

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
    
    @NotNull
    private String name;
    
    private String topic;
    private String description;
    
    @NotNull
    @Column(columnDefinition = "tinyint")
    private Integer settings;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdt;
    
    @LastModifiedDate
    private LocalDateTime modifydt;
    
    @OneToMany(mappedBy = "channel", orphanRemoval = true)
    @BatchSize(size=5)
    List<AccountChannel> accounts;
    
    @Getter
    public static class CreateDto{
        private Long workspaceId;
        private String name;
        private String topic;
        private String description;

        public Channel toEntity(Workspace workspace){
            return Channel.builder()
                .workspace(workspace)
                .name(name)
                .topic(topic)
                .description(description)
                .settings(0)
                .createdt(LocalDateTime.now())
                .modifydt(LocalDateTime.now())
                .build();
        }
    }
    
    public static class EditDto{
        private String name;
        private String topic;
        private String description;
        private Integer settings;
        
        public Channel toEntity(Channel channel){
            if(name != null){
                channel.setName(name);
            }
            if(topic != null){
                channel.setTopic(topic);
            }
            if(description != null){
                channel.setDescription(description);
            }
            if(settings != null){
                channel.setSettings(settings);
            }
            return channel;
        }
    }
    
    @Getter
    public static class ExportDto{
        private Long id;
        private Workspace.ExportDto workspace;
        private String name;
        private String topic;
        private String description;
        private Integer settings;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime createDt;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime modifyDt;

        @QueryProjection
        public ExportDto(Long id, Workspace workspace, String name,
                         String topic, String description, Integer settings,
                         LocalDateTime createDt, LocalDateTime modifyDt) {
            this.id = id;
            this.workspace = workspace.export();
            this.name = name;
            this.topic = topic;
            this.description = description;
            this.settings = settings;
            this.createDt = createDt;
            this.modifyDt = modifyDt;
        }
    }
    
    public ExportDto export(){
        return new ExportDto(
                id, workspace, name, topic, description, settings, createdt, modifydt
        );
    }

    // WorkspaceRepository::getAllChannels에서 native query의 결과를 출력하기 위한 인터페이스
    public interface ExportSimpleDto{
        Long getId();
        String getName();
    }

    // QueryDSL은 QueryProjection 된 Q Class를 요구: implementation class 구현
    @Getter
    public static class ExportSimpleDtoImpl implements ExportSimpleDto{
        Long id;
        String name;

        @QueryProjection
        public ExportSimpleDtoImpl(Long id, String name) {
            this.id = id;
            this.name = name;
        }
    }

    @Getter
    public static class FindDto{
        private Long workspaceId;
        private String name;
    }
}
