package lastpunch.workspace.common.exception;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import lastpunch.workspace.common.StatusCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class DBExceptionMapper{
    private final Map<String, BusinessException> foreignKeyExceptionMap;
    private final Map<String, BusinessException> duplicateExceptionMap;
    private final Pattern keyPattern;
    Logger logger;
    
    public DBExceptionMapper(){
        foreignKeyExceptionMap = Map.of(
            "FOREIGN KEY (`accountId`)", new BusinessException(StatusCode.ACCOUNT_NOT_EXIST),
            "FOREIGN KEY (`workspaceId`)", new BusinessException(StatusCode.WORKSPACE_NOT_EXIST),
            "FOREIGN KEY (`channelId`)", new BusinessException(StatusCode.CHANNEL_NOT_EXIST),
            "FOREIGN KEY (`roleId`)", new BusinessException(StatusCode.ROLE_NOT_EXIST)
        );
        duplicateExceptionMap = Map.of(
            "channel", new BusinessException(StatusCode.CHANNEL_ALREADY_EXIST),
            "accountworkspace", new BusinessException(StatusCode.ACCOUNTWORKSPACE_ALREADY_EXIST),
            "accountchannel", new BusinessException(StatusCode.ACCOUNTCHANNEL_ALREADY_EXIST)
        );
        keyPattern = Pattern.compile(
            "(FOREIGN KEY \\(`\\w+`\\))"
            + "|(Duplicate entry '[\\w\\s-]+' for key '[\\w.-]+')"
        );
        logger = LoggerFactory.getLogger(DBExceptionMapper.class);
    }
    
    public BusinessException getException(Exception e){
        Throwable throwable = e.getCause();
        if(e.getCause() != null){
            throwable = throwable.getCause();
            if(throwable != null){
                Matcher matcher = keyPattern.matcher(throwable.toString());
                if(matcher.find()){
                    String key = matcher.group();
                    if(key.contains("Duplicate entry")){
                        key = key.substring(key.lastIndexOf(" ")+2, key.lastIndexOf("."));
                        if(duplicateExceptionMap.containsKey(key)){
                            logger.info("[DBExceptionMapper] Duplicate Constraint Exception Found");
                            return duplicateExceptionMap.get(key);
                        }
                    } else if(foreignKeyExceptionMap.containsKey(key)){
                        logger.info("[DBExceptionMapper] Foreign Key Constraint Exception Found");
                        return foreignKeyExceptionMap.get(key);
                    }
                }
            }
        }
        logger.info("[DBExceptionMapper] No Business Exception to be mapped, hand it over to global handler");
        return null;
    }
}
