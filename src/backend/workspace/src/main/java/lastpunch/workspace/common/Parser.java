package lastpunch.workspace.common;

import java.util.Map;
import lastpunch.workspace.common.exception.BusinessException;

public class Parser{
    public static Long getHeaderId(Map<String, Object> header){
        try{
            String str = (String) header.get("userid");
            return Long.parseLong(str);
        } catch(Exception e){
            throw new BusinessException(StatusCode.INVALID_USERID);
        }
    }
}
