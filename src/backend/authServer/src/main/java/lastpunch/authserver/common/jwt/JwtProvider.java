package lastpunch.authserver.common.jwt;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lastpunch.authserver.entity.Account;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

@Component
public class JwtProvider implements InitializingBean {
    
    public final static long ACCESS_TOKEN_VALIDATION_SEC = 1000 * 60 * 10; // 10분
    public static final long REFRESH_TOKEN_VALIDATION_SEC = 1000 * 60 * 60 * 24 * 7; // 1주
    
    @Value("${jwt.secret}")
    private String secret;
    private Key key;
    
    @Override
    public void afterPropertiesSet() throws Exception {
        byte[] keyBytes = Decoders.BASE64.decode(secret);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }
    
    public String createToken(Account account, Long validation_sec){
        String authorities = account.getStatus();
        Date expire = new Date((new Date()).getTime() + validation_sec);
        
        return Jwts.builder()
            .setSubject(account.getEmail())
            .claim("auth", authorities)
            .claim("userId", account.getId())
            .signWith(key, SignatureAlgorithm.HS512)
            .setExpiration(expire)
            .compact();
    }
    
    public String createAccessToken(Account account){
        return createToken(account, ACCESS_TOKEN_VALIDATION_SEC);
    }
    
    public String createRefreshToken(Account account){
        return createToken(account, REFRESH_TOKEN_VALIDATION_SEC);
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
        Claims claims = extractClaims(token);
        return claims.getExpiration().after(new Date());
    }
    
    public Long getUserId (String token){
        Claims claims = extractClaims(token);
        return ((Number) claims.get("userId")).longValue();
    }
    
    public String getEmail (String token){
        Claims claims = extractClaims(token);
        return claims.getSubject();
    }
    
}
