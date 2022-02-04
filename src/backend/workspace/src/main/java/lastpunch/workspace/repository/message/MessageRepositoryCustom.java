package lastpunch.workspace.repository.message;

import java.util.List;
import java.util.Map;
import lastpunch.workspace.entity.Message;

public interface MessageRepositoryCustom{
    Map<String, Message> getRecentDMs(List<String> dmList);
}
