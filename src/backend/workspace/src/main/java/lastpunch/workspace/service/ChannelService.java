package lastpunch.workspace.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.entity.AccountWorkspace;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.repository.AccountChannelRepository;
import lastpunch.workspace.repository.AccountWorkspaceRepository;
import lastpunch.workspace.repository.channel.ChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ChannelService{
    private final ChannelRepository channelRepository;
    private final AccountWorkspaceRepository accountWorkspaceRepository;
    private final AccountChannelRepository accountChannelRepository;
    private final CommonService commonService;
    private final DBExceptionMapper dbExceptionMapper;
    
    @Autowired
    public ChannelService(
            ChannelRepository channelRepository,
            AccountWorkspaceRepository accountWorkspaceRepository,
            AccountChannelRepository accountChannelRepository,
            CommonService commonService,
            DBExceptionMapper dbExceptionMapper){
        this.channelRepository = channelRepository;
        this.accountWorkspaceRepository = accountWorkspaceRepository;
        this.accountChannelRepository = accountChannelRepository;
        this.commonService = commonService;
        this.dbExceptionMapper = dbExceptionMapper;
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of(
            "channel", commonService.getChannel(id).exportWithOwner(channelRepository.getOwnerOfChannel(id))
        );
    }
    
    public Map<String, Object> getMembers(Long id, Pageable pageable){
        return Map.of("members", channelRepository.getMembers(id, pageable));
    }
    
    public Map<String, Object> create(Long requesterId, Channel.CreateDto createDto){
        try{
            // ?????? ??????: ?????? ????????????????????? ????????? ????????? ????????? ????????? ??? ??????
            if(accountWorkspaceRepository.get(requesterId, createDto.getWorkspaceId()).isEmpty()){
                throw new BusinessException(StatusCode.PERMISSION_DENIED);
            }
            
            Channel newChannel = channelRepository.save(
                createDto.toEntity(
                    commonService.getWorkspace(createDto.getWorkspaceId())
                )
            );
            accountChannelRepository.add(requesterId, newChannel.getId(), RoleType.OWNER.getId());
            return Map.of("channel", newChannel.export());
        } catch(DataIntegrityViolationException e){
            // DB ?????? ???????????? ?????? ?????? ???, BusinessException??? ????????? ????????? ????????? ??????????????? ??????
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
    
    public Map<String, Object> edit(Long channelId, Channel.EditDto editDto, Long requesterId){
        Channel channel = commonService.getChannel(channelId);
        Optional<AccountChannel.Dto> channelPermission = accountChannelRepository.get(
            requesterId, channelId
        );
        Optional<AccountWorkspace.Dto> workspacePermission = accountWorkspaceRepository.get(
            requesterId, channel.getWorkspace().getId()
        );
    
        // ?????? ??????: ????????? ?????????/????????? ?????? ?????? ????????? ?????? ????????????????????? ?????????/???????????? ????????? ?????? ????????? ????????? ??? ??????
        if(channelPermission.isPresent() && workspacePermission.isPresent()){
            if(RoleType.toEnum(channelPermission.get().getRoleId()).hasPermission()
                    || RoleType.toEnum(workspacePermission.get().getRoleId()).hasPermission()){
                channelRepository.save(editDto.toEntity(channel));
                return new HashMap<>(); // ?????? ?????? map: FE??? ???????????? ????????? response ??????
            }
        }
        throw new BusinessException(StatusCode.PERMISSION_DENIED);
    }
    
    public Map<String, Object> delete(Long channelId, Long requesterId){
        try{
            Channel channel = commonService.getChannel(channelId);
            Optional<AccountChannel.Dto> channelPermission = accountChannelRepository.get(
                requesterId, channelId
            );
            Optional<AccountWorkspace.Dto> workspacePermission = accountWorkspaceRepository.get(
                requesterId, channel.getWorkspace().getId()
            );
    
            // ?????? ??????: ????????? ?????????/????????? ?????? ?????? ????????? ?????? ????????????????????? ?????????/???????????? ????????? ????????? ????????? ??? ??????
            if(channelPermission.isPresent() && workspacePermission.isPresent()){
                if(RoleType.toEnum(channelPermission.get().getRoleId()).hasPermission()
                        || RoleType.toEnum(workspacePermission.get().getRoleId()).hasPermission()){
                    channelRepository.deleteById(channelId);
                    return new HashMap<>(); // ?????? ?????? map: FE??? ???????????? ????????? response ??????
                }
            }
            throw new BusinessException(StatusCode.PERMISSION_DENIED);
        } catch(EmptyResultDataAccessException e){
            throw new BusinessException(StatusCode.CHANNEL_NOT_EXIST);
        }
    }

    public Map<String, Object> getByName(Long workspaceId, String name, Pageable pageable){
        if(workspaceId == null || name == null){
            throw new BusinessException(StatusCode.INVALID_PARAMETERS);
        }
        return Map.of(
                "channels", channelRepository.findByName(workspaceId, name, pageable)
        );
    }
}
