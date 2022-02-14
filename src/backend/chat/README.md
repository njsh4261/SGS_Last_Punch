# Chat
- Snack의 채팅 기능을 제공하기 위한 서버
- Topic exchange를 사용한 채팅 채널 분리
- DB에 채팅 메시지를 실시간으로 nonblocking하게 저장
- REST API를 통해 DB에 저장된 채팅 메시지 제공

## 기술 스택
![Generic badge](https://img.shields.io/badge/11-OpenJDK-537E99.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-SpringBoot-6DB33F.svg)
![Generic badge](https://img.shields.io/badge/3.9.13-RabbiMQ-FF6600.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-MongoDB-81C564.svg)

## Setup & How To Run

### 백엔드 통합 환경에서 실행
- `/src/backend` 폴더에서 `docker-compose pull; docker-compose up --build` 명령어로 실행 

## APIs
[API 문서 링크](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/docs/API_references/chat_apis.md) 를 참조
