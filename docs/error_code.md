# Error Codes
- Format: XXYYY
- XX는 서버 코드, YYY는 에러 번호
- XX000: 해당 서버에서 정상적인 결과가 반환되었음을 나타냄
- 서버 코드: 게이트웨이(10), 인증(11), 웨크스페이스(12), 프리젠스(13), 채팅(14), 실시간노트편집(15), 알림(16), 파일(17), 검색(18)


## 게이트웨이(gateway) 10

| ErrorCode | Error Message           | HTTP Status Code                      | Description             | 
|-----------|-------------------------|---------------------------------------|-------------------------|
| 10001     | NO_TOKEN                | HttpStatus.UNAUTHORIZED(401)          | 토큰이 존재하지 않습니다.          |
| 10002     | EXPIRED_TOKEN           | HttpStatus.UNAUTHORIZED(401)          | 토큰이 만료되었습니다.            |   
| 10003     | MALFORMED_TOKEN         | HttpStatus.UNAUTHORIZED(401)          | 토큰이 유효하지 않습니다.          |    
| 10004     | DECODING_EXCEPTION      | HttpStatus.UNAUTHORIZED(401)          | 토큰 디코딩 과정에서 에러가 발생했습니다. | 
| 10999     | INTERNAL_SERVER_ERROR   | HttpStatus.INTERNAL_SERVER_ERROR(500) | 게이트웨이에서 에러가 발생했습니다.     |  


## 인증 서버(auth-server) 11

| ErrorCode | Error Message              | HTTP Status Code    | Description                 | 
|-----------|----------------------------|---------------------|-----------------------------|
| 11001     | DUPLICATE_EMAIL            | HttpStatus.OK(200)  | 이미 가입된 이메일입니다.              |
| 11002     | BAD_CREDENTIALS            | HttpStatus.OK(200)  | 이메일 혹은 패스워드를 잘못 입력했습니다.     |   
| 11003     | INVALID_VERIFY_CODE        | HttpStatus.OK(200)  | 이메일 인증 코드가 유효하지 않습니다.       |    
| 11004     | MODIFIED_EMAIL_VERIFY_DATA | HttpStatus.OK(200)  | 이메일 인증 시 사용했던 데이터가 변조되었습니다. | 
| 11005     | MAIL_SEND_ERROR            | HttpStatus.OK(200)  | 인증 이메일 전송에 문제가 발생했습니다.      |  
| 11006     | INVALID_REFRESH_TOKEN      | HttpStatus.OK(200)  | 유효하지 않은 refresh token 입니다.  |


## 워크스페이스 서버(workspace) 12

| ErrorCode | Error Message                  | HTTP Status Code   | Description                 | 
|-----------|--------------------------------|--------------------|-----------------------------|
| 12001     | WORKSPACE_NOT_EXIST            | HttpStatus.OK(200) | 존재하지 않는 워크스페이스입니다.          |
| 12002     | ACCOUNT_NOT_EXIST              | HttpStatus.OK(200) | 존재하지 않는 사용자입니다.             |
| 12003     | CHANNEL_NOT_EXIST              | HttpStatus.OK(200) | 존재하지 않는 채널입니다.              |
| 12004     | ACCOUNTWORKSPACE_NOT_EXIST     | HttpStatus.OK(200) | 존재하지 않는 유저와 워크스페이스 간 관계입니다. |
| 12005     | ACCOUNTWORKSPACE_ALREADY_EXIST | HttpStatus.OK(200) | 유저와 워크스페이스 간 관계가 이미 존재합니다.  |
| 12006     | ACCOUNTCHANNEL_NOT_EXIST       | HttpStatus.OK(200) | 존재하지 않는 유저와 채널 간 관계입니다.     |
| 12007     | ACCOUNTCHANNEL_ALREADY_EXIST   | HttpStatus.OK(200) | 유저와 채널 간 관계가 이미 존재합니다.      |
| 12008     | INVALID_USERID                 | HttpStatus.OK(200) | 사용자 ID가 정상적으로 제공되지 않았습니다.   |
