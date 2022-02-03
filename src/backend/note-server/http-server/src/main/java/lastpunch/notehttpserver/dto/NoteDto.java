package lastpunch.notehttpserver.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.validation.constraints.NotNull;
import lastpunch.notehttpserver.entity.Note;
import lastpunch.notehttpserver.entity.Op;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

public class NoteDto {

    @Data
    public static class createRequest {
        @NotNull
        private Long workspaceId;
        @NotNull
        private Long channelId;
        @NotNull
        private Long creatorId;
    
        public Note toEntity(){
            String defaultContent = "["
                + "{"
                + "\"type\": \"paragraph\","
                + "\"children\": [{ \"text\": \"\" }]"
                + "}"
                + "]";
        
            return Note.builder()
                .workspaceId(workspaceId)
                .channelId(channelId)
                .creatorId(creatorId)
                .title("Untitled")
                .content(defaultContent)
                .ops(new ArrayList<Op>())
                .createDt(LocalDateTime.now())
                .modifyDt(LocalDateTime.now())
                .build();
        }
    }
    
    @Data
    public static class getResponse{
        private String id;
        private Long creatorId;
        private String title;
        private String content;
        private List<Op> ops;
        private LocalDateTime createDt;
        private LocalDateTime modifyDt;
    
        public getResponse(Note note){
            this.id = note.getId().toString();
            this.creatorId = note.getCreatorId();
            this.title = note.getTitle();
            this.content = note.getContent();
            this.ops = note.getOps();
            this.createDt = note.getCreateDt();
            this.modifyDt = note.getModifyDt();
        }
    }
    
    @Data
    public static class updateRequest {
        private String noteId;
        private String title;
        private String content;
        private LocalDateTime modifyDt;
    }
    
   @Data
    public static class noteInfo {
        private String id;
        private String title;
        private Long creatorId;
        private LocalDateTime createDt;
        private LocalDateTime modifyDt;
    
       public noteInfo(Note note){
           this.id = note.getId().toString();
           this.title = note.getTitle();
           this.creatorId = note.getCreatorId();
           this.createDt = note.getCreateDt();
           this.modifyDt = note.getModifyDt();
       }
    }
    
    @Data
    public static class titleDto {
        @NotNull
        private String noteId;
        @NotNull
        private String title;
    }
}
