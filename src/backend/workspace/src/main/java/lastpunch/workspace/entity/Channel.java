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

        public Channel toEntity(Workspace workspace){
            return Channel.builder()
                .workspace(workspace)
                .name(name)
                .topic(topic)
                .createdt(LocalDateTime.now())
                .modifydt(LocalDateTime.now())
                .build();
        }
    }
    
    public static class EditDto{
        private String name;
        private String topic;
        
        public Channel toEntity(Channel channel){
            if(name != null){
                channel.setName(name);
            }
            if(topic != null){
                channel.setTopic(topic);
            }
            if(name != null || topic != null){
                channel.setModifydt(LocalDateTime.now());
            }
            return channel;
        }
    }
    
    @Getter
    public static class ExportDto{
        private final Long id;
        private final Workspace.ExportDto workspace;
        private final String name;
        private final String topic;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private final LocalDateTime createDt;
    
        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private final LocalDateTime modifyDt;

        @QueryProjection
        public ExportDto(Long id, Workspace workspace, String name, String topic,
                         LocalDateTime createDt, LocalDateTime modifyDt) {
            this.id = id;
            this.workspace = workspace.export();
            this.name = name;
            this.topic = topic;
            this.createDt = createDt;
            this.modifyDt = modifyDt;
        }
    }
    
    public ExportDto export(){
        return new ExportDto(
            id, workspace, name, topic, createdt, modifydt
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

    @Getter
    @Builder
    public static class ExportWithOwnerDto{
        private Long id;
        private Workspace.ExportDto workspace;
        private String name;
        private String topic;

        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime createDt;

        @JsonFormat(pattern = "yyyy-MM-dd kk:mm:ss")
        private LocalDateTime modifyDt;

        private Account.ExportDto owner;
    }

    public ExportWithOwnerDto exportWithOwner(Account.ExportDto account){
        return ExportWithOwnerDto.builder()
                .id(id)
                .workspace(workspace.export())
                .name(name)
                .topic(topic)
                .createDt(createdt)
                .modifyDt(modifydt)
                .owner(account)
                .build();
    }
}
