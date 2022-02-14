# Chat
- Snack의 채팅 기능을 제공하기 위한 서버
- Topic exchange를 사용한 채팅 채널 분리
- DB에 채팅 메시지를 실시간으로 nonblocking하게 저장
- REST API를 통해 DB에 저장된 채팅 메시지 제공

## 기술 스택
![Generic badge](https://img.shields.io/badge/11-OpenJDK-537E99.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-SpringBoot-6DB33F.svg)
![Generic badge](https://img.shields.io/badge/3.9.13-RabbiMQ-FF6600.svg)
![Generic badge](https://img.shields.io/badge/5.0-MongoDB-81C564.svg)

## Setup & How To Run

### 백엔드 통합 환경에서 실행
- `/src/backend` 폴더에서 `docker-compose pull; docker-compose up --build` 명령어로 실행

### 로컬 환경에서 단독 서버로 실행 (프로토타입 사용 가능, 소스 코드 수정 필요)
- 프로젝트 빌드 및 실행 시 OpenJDK 11 필요
- 로컬에서 RabbitMQ 서버 구동 필요
  - 터미널에서 다음 명령어를 실행하여 RabbitMQ에 STOMP 플러그인을 추가해야 함
    ```
    > rabbitmq-plugins enable rabbitmq_stomp
    ```
- 로컬에서 MongoDB 서버 구동 필요
- Eureka Client에 관한 일부 라인을 비활성화 해야 함
  - `build.gradle`에서 다음 라인을 주석처리
    - `implementation 'org.springframework.cloud:spring-cloud-starter-netflix-eureka-client'`
  - `./src/main/java/lastpunch/chat/ChatApplication.java`에서 다음 라인을 주석처리
    - `import org.springframework.cloud.client.discovery.EnableDiscoveryClient;`
    - `@EnableDiscoveryClient`
- 위의 모든 설정 완료 후 터미널 통해 build & run (Windows는 gradlew.bat으로 build)
  ```
  > ./gradlew build -x test
  > java -jar ./build/libs/chat-server.jar
  ```
- `http://localhost:8083/` 주소를 통해 프로토타입 사용


## 프로젝트 구조
```
/src/main
├── resources
│   ├── static                        (채팅 서버 테스트를 위한 프론트엔드 프로토타입)
│   └── application.yml               (프로젝트 관련 설정 파일)
└── java/lastpunch/chat
    ├── common                        (상수 및 JWT 토큰 인증 코드)
    │   └── jwt                       (소켓 연결 시 JWT 토큰 인증을 위한 패키지)
    ├── config                        (STOMP, RabbitMQ, MongoDB, CORS, @Async 및 message interceptor 관련 설정)
    ├── controller                    (메시지 및 REST API 요청 수신)
    ├── entity                        (MongoDB에 저장하는 프리젠스 정보 및 관련 DTO)
    ├── repository
    │   ├── MongoDbRepository         (Spring JPA에서 제공하는 CRUD 인터페이스 활용)
    │   ├── MongoDbRepositoryCustom   (MongoTemplate을 활용한 DB 접근 메소드 정의)
    │   └── MongoDbRepositoryImpl     (DB 접근 메소드 구현)
    ├── service                       (메시지 전달 및 비즈니스 로직 처리)
    └── ChatApplication.java          (애플리케이션 실행)
```

## APIs
[API 문서 링크](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/docs/API_references/chat_apis.md) 를 참조
