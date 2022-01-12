package lastpunch.authserver.common;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter
public class StatusConverter implements AttributeConverter<String, Integer> {
    @Override
    public Integer convertToDatabaseColumn(String role) {
        if ("ROLE_VERIFY_REQUIRED".equals(role)) return 0;
        else if ("ROLE_USER".equals(role)) return 1;
        else if ("ROLE_ADMIN".equals(role)) return 2;
        return null;
    }
    
    @Override
    public String convertToEntityAttribute(Integer status) {
        if (0 == status) return "ROLE_VERIFY_REQUIRED";
        else if (1 == status) return "ROLE_USER";
        else if (2 == status) return "ROLE_ADMIN";
        return null;
    }
}