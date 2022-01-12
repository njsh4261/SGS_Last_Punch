// original source code work by Jisoo Kim

package lastpunch.workspace.common.converter;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Converter
public class MemberStatusConverter implements AttributeConverter<String, Integer> {
    private final Map<String, Integer> dbColumnMap;
    private final Map<Integer, String> entityAttributeMap;

    public MemberStatusConverter(){
        dbColumnMap = new ConcurrentHashMap<>();

        // put status here
        dbColumnMap.put("ROLE_VERIFY_REQUIRED", 0);
        dbColumnMap.put("ROLE_USER", 1);
        dbColumnMap.put("ROLE_ADMIN", 2);

        entityAttributeMap = new ConcurrentHashMap<>();
        for(Map.Entry<String, Integer> entry : dbColumnMap.entrySet()){
            entityAttributeMap.put(entry.getValue(), entry.getKey());
        }
    }

    @Override
    public Integer convertToDatabaseColumn(String role) {
        return dbColumnMap.getOrDefault(role, null);
    }
    
    @Override
    public String convertToEntityAttribute(Integer status) {
        return entityAttributeMap.getOrDefault(status, null);
    }
}