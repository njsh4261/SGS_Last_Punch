package lastpunch.workspace.controller;

import java.util.Map;
import lastpunch.workspace.common.Parser;
import lastpunch.workspace.common.Response;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.entity.Channel.CreateDto;
import lastpunch.workspace.service.ChannelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/channel")
public class ChannelController{
    private final ChannelService channelService;
    private static final int PAGE_SIZE_MEMBER = 10;
    
    @Autowired
    public ChannelController(ChannelService channelService){
        this.channelService = channelService;
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Object> getOne(@PathVariable("id") Long id){
        return Response.ok(channelService.getOne(id));
    }
    
    @GetMapping("/{id}/members")
    public ResponseEntity<Object> getMembers(
            @PathVariable("id") Long id,
            @PageableDefault(size = PAGE_SIZE_MEMBER) Pageable pageable){
        return Response.ok(channelService.getMembers(id, pageable));
    }
    
    @PostMapping
    public ResponseEntity<Object> create(
            @RequestHeader Map<String, Object> header,
            @RequestBody CreateDto channelCreateDto){
        return Response.ok(
            channelService.create(Parser.getHeaderId(header), channelCreateDto)
        );
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Object> edit(
            @PathVariable("id") Long id,
            @RequestBody Channel.EditDto editDto,
            @RequestHeader Map<String, Object> header){
        return Response.ok(channelService.edit(id, editDto, Parser.getHeaderId(header)));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(
            @PathVariable("id") Long id, @RequestHeader Map<String, Object> header){
        return Response.ok(channelService.delete(id, Parser.getHeaderId(header)));
    }

    @PostMapping("/find")
    public ResponseEntity<Object> getChannelsByName(
        @RequestBody Channel.FindDto channelFindDto,
        @PageableDefault Pageable pageable
    ){
        return Response.ok(
                channelService.getByName(
                    channelFindDto.getWorkspaceId(), channelFindDto.getName(), pageable
                )
        );
    }
}
