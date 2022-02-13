# Presence
- Snack에 접속한 사용자의 현재 상태를 관리하는 기능을 제공하는 서버
- WebSocket(STOMP 프로토콜 사용) 연결을 통한 메시징으로 사용자의 상태 변화 송수신
- API 및 기초적인 동작 테스르를 위한 프로토타입 제공

## 기술 스택
![Generic badge](https://img.shields.io/badge/11-OpenJDK-537E99.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-SpringBoot-6DB33F.svg)
![Generic badge](https://img.shields.io/badge/3.9.13-RabbiMQ-FF6600.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-MongoDB-81C564.svg)

## Setup & HOW TO RUN

### 백엔드 통합 환경에서 실행
- `/src/backend` 폴더에서 `docker-compose pull; docker-compose up --build` 명령어로 실행 

### 단독 서버로 가동 (with prototype client)
- 로컬 환경에서 MongoDB 및 RabbitMQ가 준비되어 있어야 함 (Docker 혹은 로컬 프로세스로 실행)
- STOMP 프로토콜 사용을 위해 RabbitMQ에 plugin을 설치
  - 터미널에서 `> rabbitmq-plugins enable rabbitmq_stomp` 명령어 실행
- 제공된 jar 파일을 통해 서버 가동: `> java -jar ./build/libs/presence-server-with-prototype.jar`

## How To Use Prototype
![image](https://user-images.githubusercontent.com/54832818/150924382-95512f7d-20df-41dd-bfce-de4f79168e99.png)
- user name, channel id를 입력하고 Connect 버튼 누르기
- 메시지를 입력하고 send를 누르면 메시지가 전송되고, 같은 채널에서 전송된 메시지들이 하단에 출력됨
- 같은 채널의 메시지만 볼 수 있고, 채널이 다르면 메시지가 보이지 않음
- Disconnect 버튼을 눌러서 소켓 연결을 해제할 수 있음

## APIs
[API 문서 링크](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/docs/API_references/presence_apis.md) 를 참조
