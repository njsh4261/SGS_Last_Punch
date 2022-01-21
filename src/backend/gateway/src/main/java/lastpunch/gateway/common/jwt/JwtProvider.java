package lastpunch.gateway.common.jwt;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtProvider implements InitializingBean {
    private static final long serialVersionUID = 1234567890123456L;
    
    public final static long ACCESS_TOKEN_VALIDATION_SEC = 1000 * 60 * 10; // 10분
    public static final long REFRESH_TOKEN_VALIDATION_SEC = 1000 * 60 * 60 * 24 * 7; // 1주
    
    @Value("${jwt.secret}")
    private String secret;
    private Key key;
    private Claims claims = null;
    
    @Override
    public void afterPropertiesSet() throws Exception {
        byte[] keyBytes = Decoders.BASE64.decode(secret);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }
    
    public Claims extractClaims(String token) throws ExpiredJwtException {
        Claims claims = Jwts
            .parserBuilder()
            .setSigningKey(key)
            .build()
            .parseClaimsJws(token)
            .getBody();
        return claims;
    }
    
    public boolean validateToken(String token){
        claims = extractClaims(token);
        return claims.getExpiration().after(new Date());
    }
    
    public String getUsername(){
        return claims.getSubject();
    }
    
    public Long getUserId(){
        return (Long) claims.get("userId");
    }
}