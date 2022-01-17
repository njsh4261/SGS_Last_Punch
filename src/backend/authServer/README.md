# Auth Server
로그인(토큰 발행), 회원가입
<br></br>

# 추가 설정
src/backend/authServer/src/main/resources 폴더에 application-lastpunch.properties 생성
<pre>
spring.datasource.username=[sql 유저네임]
spring.datasource.password=[sql 비밀번호]
jwt.secret=[jwt 시크릿 키]
</pre>
<br></br>