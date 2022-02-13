# 인증 서비스

MSA 구조의 로그인, 회원가입, 토큰 인증 시스템
1) 인증 서버: 로그인(토큰 발행), 회원가입, 이메일 인증
2) Spring Cloud Gateway: CORS 설정, 토큰 검증, LB
   (디렉토리: https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/gateway)
- Spring Cloud Eureka를 사용하여 서비스 디스커버리
<br></br>

## 사용 기술
<pre>
- Spring Boot
- JWT
- Redis
- MySQL
</pre>

## 아키텍쳐
<kbd>
<img width="800" alt="Screen Shot 2022-02-11 at 5 46 04 PM" src="https://user-images.githubusercontent.com/47516074/153561878-d594ac21-61e0-4a96-a92d-4d30d9837ef0.png">
</kbd>
<br></br>

# 기능 및 동작 방식
### JWT
토큰은 JWT(비밀키를 사용해 서명한 JSON 형태 데이터) 사용. 사용자 인증 정보로 토큰을 발급하기 때문에 추후 인증이 필요하면 토큰만으로 사용자 인증 가능. 비대칭키 암호화 방식을 사용하여 서버에서는 시그니처를 복호화를 통해 토큰의 유효성 검증.
### Access Token, Refresh Token
사용자는 쿠키(http-only) Access Token과 Refresh Token을 서버로 보냄. Access Token으로 인증하고 만료되었다면 Refresh Token으로 새 Access Token을 발급받음.
Access Token은 짧은 시간에만 사용하도록 해서 탈취 피해를 줄이고, Refresh Token은 탈취당하면 유효시간 동안 계속 Access Token을 발급받을 수 있고 서버에서 이미 발급한 토큰을 만료시킬 수도 없기 때문에 Redis에 저장하여 유효한 Refresh Token인지 표시.

## 1. 회원 가입
1) 입력받은 사용자 정보를 DB에 저장
- 패스워드는 Spring Security의 BCryptPasswordEncoder 사용해서 암호화
- BCrypt를 사용하면 salt와 비밀번호를 함께 암호한 결과를 주기 때문에 따로 salt를 만들어 저장할 필요가 없음
- 사용자의 default 권한은 ROLE_VERIFY_REQUIRED로 등록
2) 사용자 이메일로 이메일 인증 요청 전송
- 스프링이 제공하는 MailSender 로 SMTP 사용
- 랜덤한 UUID로 인증 링크를 만든 후 전송, Redis에 "UUID: username"을 저장(유효시간 5분으로 설정)
3) 이메일 인증 완료
- 사용자가 링크에 접속하면 Redis에서 username을 찾고, 해당하는 사용자의 권한을 ROLE_USER로 변경

## 2. 로그인, 로그아웃
로그인
1) 입력받은 로그인 정보가 DB와 일치하는지 확인
2) 유저 정보를 사용해 Access Token과 Refresh Token 발행 (각각 유효시간 10분, 1주일)
3) Redis에 Refresh Token 저장
4) Access Token과 Refresh Token를 쿠키에 저장

로그아웃
1) 쿠키의 Access Token과 Refresh Token 삭제
2) Redis에 저장된 Refresh Token 삭제

## 3. 토큰 인증
Spring Security에 custom JWT 인증 filter를 만들어 UsernamePasswordAuthenticationFilter 전에 등록

case 1. Access Token 유효
- 토큰에서 Authentication 받아서 Security Context에 저장

case 2. Access Token 만료, 유효한 Refresh Token 존재
- Refresh Token 이 Redis에 저장된 정보와 일치하면 Access Token 재발급(쿠키)
- Security Context에 Authentication 설정

case 3. Access Token, Refresh Token 둘 다 유효하지 않음
- AuthenticationEntryPoint에서 인증 확인, AccessDeniedHandler에서 인가 확인하여 에러 반환
- 재로그인 필요

<br></br>

# User DB 테이블
<br></br> 

# 추가 설정
src/backend/authServer/src/main/resources 폴더에 application-lastpunch.properties 생성
<pre>
spring.datasource.username=[sql 유저네임]
spring.datasource.password=[sql 비밀번호]
jwt.secret=[jwt 시크릿 키]
</pre>
<br></br>