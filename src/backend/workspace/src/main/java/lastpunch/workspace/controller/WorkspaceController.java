package lastpunch.workspace.controller;

import lastpunch.workspace.service.WorkspaceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/workspace")
public class WorkspaceController{
    private WorkspaceService workspaceService;
    
    @Autowired
    public WorkspaceController(WorkspaceService workspaceService) {
        this.workspaceService = workspaceService;
    }
    
    @GetMapping
    public ResponseEntity<Object> getWorkspaceList(){
    
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Object> getOneWorkspace(@PathVariable("id") Long id){
    
    }
    
    @PostMapping
    public ResponseEntity<Object> createWorkspace(){
    
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Object> editWorkspace(@PathVariable("id") Long id) {
    
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteWorkspace(@PathVariable("id") Long id){
    
    }
    
}
