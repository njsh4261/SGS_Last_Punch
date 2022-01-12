package lastpunch.workspace.service;

import lastpunch.workspace.dto.MemberWorkspaceDto;
import lastpunch.workspace.entity.MemberWorkspace;
import lastpunch.workspace.repository.MemberWorkspaceRepository;
import org.springframework.stereotype.Service;

@Service
public class MemberWorkspaceService{
    private MemberWorkspaceRepository memberWorkspaceRepository;

    public MemberWorkspaceService(MemberWorkspaceRepository memberWorkspaceRepository) {
        this.memberWorkspaceRepository = memberWorkspaceRepository;
    }

    public MemberWorkspace addNewMember(MemberWorkspaceDto memberWorkspaceDto){
        return memberWorkspaceRepository.save(memberWorkspaceDto.toEntity());
    }

    public void deleteMember(MemberWorkspaceDto memberWorkspaceDto){
        memberWorkspaceRepository.deleteByWorkspaceIdAndMemberId(
                memberWorkspaceDto.getWorkspaceId(), memberWorkspaceDto.getMemberId()
        );
    }
}
