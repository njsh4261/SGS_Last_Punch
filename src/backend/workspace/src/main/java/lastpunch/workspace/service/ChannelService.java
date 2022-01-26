package lastpunch.workspace.service;

import lastpunch.workspace.common.StatusCode;
import lastpunch.workspace.common.exception.BusinessException;
import lastpunch.workspace.common.exception.DBExceptionMapper;
import lastpunch.workspace.common.type.RoleType;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.repository.AccountChannelRepository;
import lastpunch.workspace.repository.channel.ChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class ChannelService{
    private final ChannelRepository channelRepository;
    private final AccountChannelRepository accountChannelRepository;
    private final CommonService commonService;
    private final DBExceptionMapper dbExceptionMapper;
    
    @Autowired
    public ChannelService(
            ChannelRepository channelRepository,
            AccountChannelRepository accountChannelRepository,
            CommonService commonService,
            DBExceptionMapper dbExceptionMapper){
        this.channelRepository = channelRepository;
        this.accountChannelRepository = accountChannelRepository;
        this.commonService = commonService;
        this.dbExceptionMapper = dbExceptionMapper;
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of("channel", commonService.getChannel(id).export());
    }
    
    public Object getMembers(Long id, Pageable pageable){
        return Map.of("members", channelRepository.getMembers(id, pageable));
    }
    
    public Map<String, Object> create(Long userId, Channel.CreateDto createDto){
        try{
            commonService.getAccount(userId); // userId validation 용도의 호출
            Channel newChannel = channelRepository.save(
                createDto.toEntity(
                    commonService.getWorkspace(createDto.getWorkspaceId())
                )
            );
            accountChannelRepository.add(userId, newChannel.getId(), RoleType.OWNER.getId());
            return Map.of("channel", newChannel.export());
        } catch(DataIntegrityViolationException e){
            BusinessException be = dbExceptionMapper.getException(e);
            throw (be != null) ? be : e;
        }
    }
    
    public void edit(Long id, Channel.EditDto editDto){
        channelRepository.save(editDto.toEntity(commonService.getChannel(id)));
    }
    
    public void delete(Long id){
        try{
            channelRepository.deleteById(id);
        } catch(EmptyResultDataAccessException e){
            throw new BusinessException(StatusCode.CHANNEL_NOT_EXIST);
        }
    }
}
