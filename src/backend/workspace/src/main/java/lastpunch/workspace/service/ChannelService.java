package lastpunch.workspace.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import lastpunch.workspace.entity.Account.ExportDto;
import lastpunch.workspace.entity.Channel;
import lastpunch.workspace.repository.account.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import lastpunch.workspace.entity.Account;
import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.repository.channel.ChannelRepository;

@Service
public class ChannelService{
    private final ChannelRepository channelRepository;
    private final CommonService commonService;
    private final AccountRepository accountRepository;
    
    @Autowired
    public ChannelService(
            ChannelRepository channelRepository,
            CommonService commonService,
            AccountRepository accountRepository){
        this.channelRepository = channelRepository;
        this.commonService = commonService;
        this.accountRepository = accountRepository;
    }
    
    public Map<String, Object> getOne(Long id){
        return Map.of(
            "channel", commonService.getChannel(id).export()
        );
    }
    
    public Object getMembers(Long id, Pageable pageable){
//        return Map.of(
//            "members", commonService.getChannel(id).getAccounts()
//                    .stream().map(AccountChannel::getAccount).map(Account::export)
//                    .collect(Collectors.toList())
//        );
//        List<ExportDto> dtos = accountRepository.getMembersOfChannel(id, pageable);
//        return Map.of(
//            "members", dtos == null ? "null item" : dtos
//        );
        return null;
    }
    
    public void create(Channel.ImportDto channelImportDto){
//        channelRepository.create(channelImportDto);
    }
    
    public void edit(Channel.ImportDto channelImportDto, Long id){
        // TODO: ChannelRepository를 class로 바꾸고,
        //  parameter로 받는 ChannelEditDto의 메소드를 이용해 query를 동적으로 짤 수 있는 방법을 찾아봐야 함.
    }
    
    public void delete(Long id){
        channelRepository.deleteById(id);
    }
}
