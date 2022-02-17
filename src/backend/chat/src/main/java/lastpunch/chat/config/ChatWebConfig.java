package lastpunch.chat.config;

import lastpunch.chat.common.MessageType;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ChatWebConfig implements WebMvcConfigurer{
    public static class StringToMessageTypeConverter implements Converter<String, MessageType>{
        @Override
        public MessageType convert(String source){
            return MessageType.toEnum(source);
        }
    }
    
    @Override
    public void addFormatters(FormatterRegistry registry){
        registry.addConverter(new StringToMessageTypeConverter());
    }
}
