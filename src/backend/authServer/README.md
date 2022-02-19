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
프론트 요청에 따라 회원가입을 하기 전 이메일 인증을 통과해야하는 방식으로 구현 

1) 사용자 이메일로 이메일 인증 요청 메일 전송
- 스프링이 제공하는 MailSender 로 SMTP 사용
- 6자리 코드를 생성하여 Redis에 "이메일: 인증코드"를 저장 (유효시간 10분으로 설정)
2) 이메일 인증
3) 회원가입 (입력받은 사용자 정보를 DB에 저장)
- 패스워드는 Spring Security의 BCryptPasswordEncoder 사용해서 암호화
- BCrypt를 사용하면 salt와 비밀번호를 함께 암호한 결과를 주기 때문에 따로 salt를 만들어 저장할 필요가 없음
- 사용자의 default 권한은 ROLE_USER로 등록

이메일 전송에 시간이 몇초정도 소요되어서 이메일 전송은 비동기적으로 처리하였습니다.

## 2. 로그인, 로그아웃
로그인
1) 입력받은 로그인 정보가 DB와 일치하는지 확인
2) 유저 정보를 사용해 Access Token과 Refresh Token 발행 (각각 유효시간 10분, 1주일)
3) Redis에 Refresh Token 저장
4) Access Token과 Refresh Token을 응답으로 클라이언트에게 전송

로그아웃
1) 클라이언트는 저장해둔 Access Token와 Refresh Token을 삭제
2) 인증 서버에서 Redis에 저장된 Refresh Token 삭제

## 3. 토큰 인증
gateway에서 라우팅하기 전 filter를 거치도록 만들어 토큰 유효성 검증

case 1. Access Token 유효
- 클라이언트가 원래 요청했던 API로 라우팅

case 2. Access Token 만료, 유효한 Refresh Token 존재
- Access Token이 만료되었다는 응답을 클라이언트에 보내면, 클라이언트는 /auth/reissue API로 Refresh Token를 헤더에 넣어 인증 서버에 새로운 Access Token 요청 
- Refresh Token이 유효하지 않으면 gateway에서 에러 응답
- Refresh Token 이 Redis에 저장된 정보와 일치하면 Access Token을 재발급하고 응답으로 보냄

case 3. Access Token, Refresh Token 둘 다 유효하지 않음
- 재로그인 필요

<br></br>

## 인증 서버 개선
1) Spring Security의 기능은 BCryptPasswordEncoder만 사용하도록 리팩토링
2) BCryptPasswordEncoder의 해시 strength 4로 조정 

## gateway 추가 설명
- 라우팅은 GatewayApplication.java 파일에 작성 (Spring Cloud Eureka를 사용해 각 서버들의 주소를 받아 라우팅)
- `/filter`: 라우팅 하기 전 AccessTokenFilter를 거쳐 access token이 유효한 경우에만 요청한 주소로 라우팅
  만약 유효하지 않으면 클라이언트에서 /auth/reissue API로 요청을 보내 토큰을 재발급받는데 이 경우에는 RefreshTokenFilter를 거쳐 refresh token이 유효한지 검증한 후 라우팅
- 유저ID가 필요한 API들이 있어서 Access Token에 있는 유저ID를 gateway에서 유효성 검증할 때 꺼내서 request 헤더에 넣어줌 
- application.yml 파일에서 CORS 설정

## API 문서
https://documenter.getpostman.com/view/7437901/UVXgLHFb 