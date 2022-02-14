package lastpunch.presence.config;

import lastpunch.presence.common.UserStatus;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class PresenceWebConfig implements WebMvcConfigurer{
    public static class StringToUserStatusConverter implements Converter<String, UserStatus>{
        @Override
        public UserStatus convert(String source){
            return UserStatus.toEnum(source);
        }
    }
    
    @Override
    public void addFormatters(FormatterRegistry registry){
        registry.addConverter(new StringToUserStatusConverter());
    }
}
