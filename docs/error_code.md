# 게이트웨이(gateway) 10

| ErrorCode | Error Message           | HTTP Status Code                      | Description             | 
|-----------|-------------------------|---------------------------------------|-------------------------|
| 10001     | NO_TOKEN                | HttpStatus.OK(200)                    | 토큰이 존재하지 않습니다.          |
| 10002     | EXPIRED_TOKEN           | HttpStatus.OK(200)                    | 토큰이 만료되었습니다.            |   
| 10003     | MALFORMED_TOKEN         | HttpStatus.OK(200)                    | 토큰이 유효하지 않습니다.          |    
| 10004     | DECODING_EXCEPTION      | HttpStatus.OK(200)                    | 토큰 디코딩 과정에서 에러가 발생했습니다. | 
| 10999     | INTERNAL_SERVER_ERROR   | HttpStatus.INTERNAL_SERVER_ERROR(500) | 게이트웨이에서 에러가 발생했습니다.     |  


# 인증 서버(auth-server) 11

| ErrorCode | Error Message              | HTTP Status Code    | Description                 | 
|-----------|----------------------------|---------------------|-----------------------------|
| 11001     | DUPLICATE_EMAIL            | HttpStatus.OK(200)  | 이미 가입된 이메일입니다.              |
| 11002     | BAD_CREDENTIALS            | HttpStatus.OK(200)  | 이메일 혹은 패스워드를 잘못 입력했습니다.     |   
| 11003     | INVALID_VERIFY_CODE        | HttpStatus.OK(200)  | 이메일 인증 코드가 유효하지 않습니다.       |    
| 11004     | MODIFIED_EMAIL_VERIFY_DATA | HttpStatus.OK(200)  | 이메일 인증 시 사용했던 데이터가 변조되었습니다. | 
| 11005     | MAIL_SEND_ERROR            | HttpStatus.OK(200)  | 인증 이메일 전송에 문제가 발생했습니다.      |  
| 11006     | INVALID_REFRESH_TOKEN      | HttpStatus.OK(200)  | 유효하지 않은 refresh token 입니다.  |