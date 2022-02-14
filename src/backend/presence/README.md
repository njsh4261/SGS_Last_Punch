# Presence
- Snack에 접속한 사용자의 현재 상태를 관리하는 기능을 제공하는 서버
- WebSocket(STOMP 프로토콜 사용) 연결을 통한 메시징으로 사용자의 상태 변화 송수신
- API 및 기초적인 동작 테스르를 위한 프로토타입 제공

## 기술 스택
![Generic badge](https://img.shields.io/badge/11-OpenJDK-537E99.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-SpringBoot-6DB33F.svg)
![Generic badge](https://img.shields.io/badge/3.9.13-RabbiMQ-FF6600.svg)
![Generic badge](https://img.shields.io/badge/5.0-MongoDB-81C564.svg)

## Setup & HOW TO RUN

### 백엔드 통합 환경에서 실행
- `/src/backend` 폴더에서 `docker-compose pull; docker-compose up --build` 명령어로 실행 

### 단독 서버로 가동 (with prototype client)
- 로컬 환경에서 MongoDB 및 RabbitMQ가 준비되어 있어야 함 (Docker 혹은 로컬 프로세스로 실행)
- STOMP 프로토콜 사용을 위해 RabbitMQ에 plugin을 설치
  - 터미널에서 `> rabbitmq-plugins enable rabbitmq_stomp` 명령어 실행
- 제공된 jar 파일을 통해 서버 가동: `> java -jar ./build/libs/presence-server-with-prototype.jar`

## How To Use Prototype
![image](https://user-images.githubusercontent.com/54832818/153785351-73c66980-d7b9-4bc5-b291-0bf05e8cd975.png)
- Workspace ID, user ID를 입력하고 Connect 버튼 누르면 하단 목록에 현재 워크스페이스에 접속 중인 멤버들의 상태가 표시됨
- User status를 입력하고 Send 버튼을 누르면 해당 워크스페이스의 모든 멤버들에게 상태 변경 사항이 전파됨
- `Get presence list` 버튼을 통해 워크스페이스에 접속 중인 멤버들의 상태 목록을 수동으로 업데이트 할 수 있음

![image](https://user-images.githubusercontent.com/54832818/153785493-5544bce3-c0ff-4a1a-a15b-010464fa992a.png)
- 멤버가 Disconnect 버튼을 클릭하거나 브라우저를 닫아서 연결이 해제되는 경우 해당 유저의 상태가 DISCONNECT 되었다는 메시지가 전파됨
  - DB에서 Disconnect된 유저의 프리젠스 정보 삭제

## 프로젝트 구조
```
/src/main
├── resources
│   ├── static                        (프리젠스 서버 테스트를 위한 프론트엔드 프로토타입)
│   └── application.yml               (프로젝트 관련 설정 파일)
└── java/lastpunch/presence
    ├── common                        (상수 및 enum, JWT 토큰 인증 코드)
    │   └── jwt                       (소켓 연결 시 JWT 토큰 인증을 위한 패키지)
    ├── config                        (STOMP, RabbitMQ, MongoDB, CORS, @Async 및 message interceptor 관련 설정)
    ├── controller                    (메시지 및 REST API 요청 수신)
    ├── entity                        (MongoDB에 저장하는 프리젠스 정보 및 관련 DTO)
    ├── repository
    │   ├── PresenceRepository        (Spring JPA에서 제공하는 CRUD 인터페이스 활용)
    │   ├── PresenceRepositoryCustom  (MongoTemplate을 활용한 DB 접근 메소드 정의)
    │   └── PresenceRepositoryImpl    (DB 접근 메소드 구현)
    ├── service                       (메시지 전달 및 비즈니스 로직 처리)
    └── PresenceApplication.java      (애플리케이션 실행)
```

## APIs
[API 문서 링크](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/docs/API_references/presence_apis.md) 를 참조
