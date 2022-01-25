package lastpunch.workspace.service;

import lastpunch.workspace.entity.AccountChannel;
import lastpunch.workspace.repository.AccountChannelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AccountChannelService{
    private final AccountChannelRepository accountChannelRepository;

    @Autowired
    public AccountChannelService(AccountChannelRepository accountChannelRepository) {
        this.accountChannelRepository = accountChannelRepository;
    }

    public void add(AccountChannel.Dto accountChannelDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountChannelRepository.add(
                accountChannelDto.getAccountId(), accountChannelDto.getChannelId(), accountChannelDto.getRoleId()
        );
    }

    public void edit(AccountChannel.Dto accountChannelDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountChannelRepository.edit(
                accountChannelDto.getAccountId(), accountChannelDto.getChannelId(), accountChannelDto.getRoleId()
        );
    }

    public void delete(AccountChannel.Dto accountChannelDto){
        // TODO: 요청자의 권한에 따라 거부하는 코드 추가
        accountChannelRepository.delete(
                accountChannelDto.getAccountId(), accountChannelDto.getChannelId()
        );
    }
}
