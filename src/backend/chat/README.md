# Chat
- 채팅 프로토타입 구현
- WebSocket, STOMP, RabbitMQ를 사용한 기본적인 채팅 기능
- 채널 분리 기능 구현

## Setup
- 프로토타입 서버 가동 전에 RabbitMQ 서버를 열어야 합니다.
- STOMP 프로토콜 사용을 위해 RabbitMQ에 plugin을 설치해야 합니다.

### 로컬에서 실행하기
- [RabbitMQ 다운로드 페이지](https://www.rabbitmq.com/download.html) 에서 OS에 따라 다운로드 & 설치
- Command Line에서 `> rabbitmq-server` 명령어 실행 (Windows는 환경변수 등록 필요)

### Docker를 통해 실행하기
- `docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.9-management`


### RabbitMQ에 STOMP 프로토콜 플러그인 추가
- Command Line에서(Docker로 실행했을 경우 Docker 내장 command line에서) `> rabbitmq-plugins enable rabbitmq_stomp` 실행

### Spring Boot 프로젝트 가동
- `~> ./gradlew run` (Windows는 `~> ./gradlew.bat run`)

## How To Use Prototype
![image](https://user-images.githubusercontent.com/54832818/150924382-95512f7d-20df-41dd-bfce-de4f79168e99.png)
- user name, channel id를 입력하고 Connect 버튼 누르기
- 메시지를 입력하고 send를 누르면 메시지가 전송되고, 같은 채널에서 전송된 메시지들이 하단에 출력됨
- 같은 채널의 메시지만 볼 수 있고, 채널이 다르면 메시지가 보이지 않음
- Disconnect 버튼을 눌러서 소켓 연결을 해제할 수 있음

## URIs
- Entry point: `/chat`
- Publish message: `/pub/chat`
- Subscibe message: `/topic/channel.{channelId}`
- STOMP 연결 예시는 `/src/main/resources/static/index.html`에서 Javasript 부분 참고

## TODO
- MongoDB를 통한 메시지 저장
- RabbitMQ의 적절한 exchange 선택에 대한 추가 리서치
