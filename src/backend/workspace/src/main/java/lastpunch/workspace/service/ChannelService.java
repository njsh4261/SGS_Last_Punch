package lastpunch.workspace.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lastpunch.workspace.dto.ChannelCreateDto;
import lastpunch.workspace.dto.ChannelEditDto;
import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.repository.ChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ChannelService{
    private final ChannelRepository channelRepository;
    private final CommonService commonService;
    
    @Autowired
    public ChannelService(ChannelRepository channelRepository, CommonService commonService){
        this.channelRepository = channelRepository;
        this.commonService = commonService;
    }
    
    public Map<String, Object> getOne(Long id, Pageable pageable){
        Channel channel = commonService.getChannel(id);
        List<AccountChannel> memberList = channel.getAccounts();
        int start = (int) pageable.getOffset();
        
        return Map.of(
            "channel", channel.export(),
            "members",
                    memberList.subList(
                        start, Math.min(memberList.size(), start + pageable.getPageSize()))
                    .stream().map(AccountChannel::getAccount).map(Account::export)
                    .collect(Collectors.toList())
        );
    }
    
    public void create(ChannelCreateDto channelCreateDto){
        channelRepository.create(channelCreateDto);
    }
    
    public void edit(ChannelEditDto channelEditDto, Long id){
        // TODO: ChannelRepository를 class로 바꾸고,
        //  parameter로 받는 ChannelEditDto의 메소드를 이용해 query를 동적으로 짤 수 있는 방법을 찾아봐야 함.
    }
    
    public void delete(Long id){
        channelRepository.deleteById(id);
    }
}
