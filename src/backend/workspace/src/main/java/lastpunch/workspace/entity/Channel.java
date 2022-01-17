package lastpunch.workspace.entity;

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
import lastpunch.workspace.dto.ChannelExportDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
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
    List<AccountChannel> accounts;
    
    public ChannelExportDto export(){
        return ChannelExportDto.builder()
            .id(id)
            .workspaceId(workspace.getId())
            .account(account.export())
            .name(name)
            .topic(topic)
            .description(description)
            .settings(settings)
            .status(status)
            .createDt(createdt)
            .modifyDt(modifydt)
            .build();
    }
}
