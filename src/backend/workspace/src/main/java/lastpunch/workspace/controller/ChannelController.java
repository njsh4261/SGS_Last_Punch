package lastpunch.workspace.controller;

import lastpunch.workspace.common.Response;
import lastpunch.workspace.common.ServerCode;
import lastpunch.workspace.dto.ChannelCreateDto;
import lastpunch.workspace.dto.ChannelEditDto;
import lastpunch.workspace.service.ChannelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/channel")
public class ChannelController{
    private final ChannelService channelService;
    private static final int PAGESIZE = 5;
    
    @Autowired
    public ChannelController(ChannelService channelService){
        this.channelService = channelService;
    }
    
    @GetMapping
    public ResponseEntity<Object> getOneChannel(
            @RequestParam("channelId") Long id, @PageableDefault(size = PAGESIZE) Pageable pageable){
        return Response.ok(ServerCode.WORKSPACE, channelService.getOne(id, pageable));
    }
    
    @PostMapping
    public ResponseEntity<Object> createChannel(@RequestBody ChannelCreateDto channelCreateDto){
        channelService.create(channelCreateDto);
        return Response.ok(ServerCode.WORKSPACE);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Object> editChannel(
            @RequestBody ChannelEditDto channelEditDto, @PathVariable("id") Long id){
        channelService.edit(channelEditDto, id);
        return Response.ok(ServerCode.WORKSPACE);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteChannel(@PathVariable("id") Long id){
        channelService.delete(id);
        return Response.ok(ServerCode.WORKSPACE);
    }
}
