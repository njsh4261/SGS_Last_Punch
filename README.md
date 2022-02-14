# <img height="25px" width="25px" src="https://user-images.githubusercontent.com/44664867/153584703-0fc34cd1-0091-46de-94ad-290415fb5fc1.png"> Snack

*여러 협업 툴을 사용하면서 새 창을 키거나 알트탭은 그만!*

*Slack과 Notion의 기능을 합친 Snack으로 쾌적한 협업을 경험해보세요!*

*워크스페이스와 채널을 생성하고 팀원을 초대하여 **채팅**하고 노트를 만들어 **공동 편집**을 할 수 있습니다!*

*Let's Snack! (url)*

<br>

## Snack의 특징

### 기본 구조

- workspace: 팀원들이 모이는 공간으로 채널을 만들거나 DM을 보낼 수 있습니다.

- channel: 워크스페이스 내의 그룹으로 채팅을 이용할 수 있습니다.

- note: 채널에 종속되어 있으며 같은 노트에 들어와 있는 사람들 간에 공동 편집을 할 수 있습니다.

<br>

### 노트(공동 편집) 기능

*편집은 선점권을 지닌 단 한 명만 할 수 있습니다!*

팀원들이 같은 문서를 편집할 때 좀 더 안전하고 편집 내용에 집중할 수 있는 경험을 제공합니다.

<br>

## 🛠 기술 스택

### iOS

<br>

![RxSwift](https://img.shields.io/badge/RxSwift-v6.2.0-b7178c?logo=reactivex) ![Swift](https://img.shields.io/badge/swift-v5.5.2-orange?logo=swift) ![Xcode](https://img.shields.io/badge/xcode-v13.2.1-blue?logo=xcode)

<br>

### Web Front

<br>

![Generic badge](https://img.shields.io/badge/17.0.2-React-skyblue.svg)
![Generic badge](https://img.shields.io/badge/4.5.4-TypeScript-green.svg)
![Generic badge](https://img.shields.io/badge/5.3.3-Styled%20Component-pink.svg)
![Generic badge](https://img.shields.io/badge/4.1.2-Redux-yellow.svg)

![Generic badge](https://img.shields.io/badge/0.59-Slate-white.svg)
![Generic badge](https://img.shields.io/badge/6.1.2-stompJS-beige.svg)
![Generic badge](https://img.shields.io/badge/1.5.2-sockJS-red.svg)
![Generic badge](https://img.shields.io/badge/2.5.1-Prettier-orange.svg)
![Generic badge](https://img.shields.io/badge/8.9.0-ESLint-blue.svg)

<br>

### Backend

<br>

![Generic badge](https://img.shields.io/badge/11-OpenJDK-537E99.svg)
![Generic badge](https://img.shields.io/badge/2.6.2-SpringBoot-6DB33F.svg)
![Generic badge](https://img.shields.io/badge/8.0-MySQL-01578B.svg)
![Generic badge](https://img.shields.io/badge/3.9.13-RabbiMQ-FF6600.svg)
![Generic badge](https://img.shields.io/badge/5.0-MongoDB-81C564.svg)
![Generic badge](https://img.shields.io/badge/6.2.6-Redis-C6302B.svg)

<br>

## 💡 기능

### 스크린샷

- [WEB](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/frontend/web#%EA%B8%B0%EB%8A%A5-)

- [iOS](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/frontend/ios#-screenshots)

### 기능 목록

- 회원가입/로그인 화면: 이메일 기반의 회원가입, 로그인

- 웰컴 화면: 워크스페이스 관련 기능 수행

  - 목록 조회

  - 선택

  - 생성

- 메인 화면: 특정 워크스페이스의 화면

  - 워크스페이스: 멤버 초대/조회, 나가기

  - 채널: 목록 조회, 생성, 선택, 나가기, 멤버 초대/조회

  - 채팅: 특정 채널에서의 채팅

  - 노트: 특정 채널에 속한 노트 목록 조회, 생성, 선택, 공동 편집

  - 유저: 워크스페이스/채널에 초대, 검색, 로그아웃, 프로필

<br>

## 🔍 아키텍처

<br>

![Architecture](https://user-images.githubusercontent.com/47516074/153741477-548d63ed-3f79-41e7-9a20-f7ea646d76db.jpg)
### 서버별 역할
- API Gateway: 라우팅, 토큰 유효성 검증, CORS 설정, 로드밸런싱
- 워크스페이스: 워크스페이스, 채널, 멤버에 대한 REST API 제공
- 채팅: WebSocket, STOMP, RabbitMQ를 사용한 Scale-out 가능한 채팅 기능
- 실시간 노트 편집: WebSocket, STOMP, Redis를 사용한 노트 공동 편집 기능
- 프리젠스: WebSocket, STOMP, RabbitMQ를 사용한 사용자 접속 상태 확인 및 접속 기록 관리
- 인증: 회원가입, 로그인, 토큰 생성
- 알림: FCM을 이용한 알림

채팅은 웹소켓으로 직접 메세지를 전달하기 때문에 안정적으로 메세지를 전달할 수 있는 RabbitMQ를 사용했고, 노트 편집 서버에서는 웹소켓으로 업데이트 여부 등 간단한 정보만을 전달하기 때문에 빠르고, 간편한 Redis를 사용했습니다.

<br>

## 역할 분담

### Frontend
[🐮 김건형](https://github.com/GeonHyeongKim):  [iOS App](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/frontend/ios)

[🐶 차효준](https://github.com/chahtk): [Web App](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/frontend/web), 노트 기획

### Backend
[🦉 김지수](https://github.com/SooKim1110): [인증 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/authServer), [노트 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/note-server), [게이트웨이](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/gateway), [Eureka 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/eureka-server)

[🐻 김지효](https://github.com/njsh4261): [워크스페이스 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/workspace), [채팅 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/chat), [프리젠스 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/presence)

<br>

## 디렉토리 구조

```
├── config (코딩 컨벤션 xml)
├── docs (API Reference, 에러코드, DB 스키마 이미지 등)
├── scripts (DB 스키마 및 테스트 데이터 스크립트)
└── src
    ├── frontend
    │   ├── ios (iOS App)
    │   └── web (Web App)
    └── backend
        ├── authServer (인증 서버)
        ├── workspace (워크스페이스 서버)
        ├── chat (채팅 서버)
        ├── note-server (노트 서버)
        ├── presence (프리젠스 서버)
        ├── gateway (게이트웨이)
        └── eureka-server (Eureka 서버)
``` 
