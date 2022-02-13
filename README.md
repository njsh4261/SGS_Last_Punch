# Snack <img height="20px" width="20px" src="https://user-images.githubusercontent.com/44664867/153584703-0fc34cd1-0091-46de-94ad-290415fb5fc1.png">

*여러 협업 툴을 사용하면서 새 창을 키거나 알트탭은 그만!*

*Slack과 Notion의 기능을 합친 Snack으로 쾌적한 협업을 경험해보세요!*

*워크스페이스와 채널을 생성하고 팀원을 초대하여 **채팅**하고 노트를 만들어 **공동 편집**을 할 수 있습니다!*

*Let's Snack! (url)*

<br>

## 기술 스택 🛠

### IOS

<br>

- badges

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

- badges

<br>

## 기능 💡

<br>

### 로그인/회원가입 페이지

|추후 추가|![loginlogout](https://user-images.githubusercontent.com/44664867/153588913-cdc4aaee-2b01-46f8-8eb5-cd070620e487.gif)|
|---|---|
|회원가입|로그인, 로그아웃|
|이메일 인증 후 회원가입|이메일로 로그인하여 localStorage에 access/refresh token 저장|

<br>

### 웰컴 페이지

유저의 워크스페이스 리스트가 렌더링 됩니다. 워크스페이스 더 보기, 선택, 개설, 로그아웃을 할 수 있습니다.

|![더보기](https://user-images.githubusercontent.com/44664867/153590304-1ea5081d-62dc-4a1c-9363-2b7d3a3d255b.gif)|![워크스페이스선택](https://user-images.githubusercontent.com/44664867/153590298-72e25cc7-4a89-4610-b02f-31750eed0335.gif)|![워크스페이스생성](https://user-images.githubusercontent.com/44664867/153590300-635c7f76-c7ce-4086-a619-c8652a3684fe.gif)|
|---|---|---|
|더 보기|선택|개설|
|페이징된 결과를 불러옵니다|워크스페이스 페이지로 이동|새 워크스페이스 생성|


<br>

### 메인 페이지 & 채팅

|![유저초대](https://user-images.githubusercontent.com/44664867/153591700-641e26c7-8faf-4b02-8d08-430f50d85f4e.gif)|미구현|미구현|
|---|---|---|
|초대|나가기|멤버 보기|
|유저 검색 후 워크스페이스/채널에 초대|워크스페이스/채널에서 나가기|워크스페이스/채널에 참가한 멤버 상태 보기|

|![homelogout](https://user-images.githubusercontent.com/44664867/153592206-4a5aaa93-3499-404b-b0f7-901c4d4df11c.gif)|미구현|![chatting](https://user-images.githubusercontent.com/44664867/153592212-0684d281-36af-422c-b72a-59f2ac252bb3.gif)|
|---|---|---|
|웰컴페이지 이동, 로그아웃|프로필|채팅|
|쿠키를 눌러 웰컴페이지로 이동하거나 로그아웃|프로필 정보 모달(구현 예정)|채팅 기능(UI 수정중)|

<br>

### 노트 기능

> *Snack에는 선점 개념이 있습니다. 동료끼리 동시에 편집하는 것은 때론 방해가 됩니다. 선점자만 문서 편집이 가능하고 실시간 업데이트 됩니다. 타이핑을 1.5초 동안 하지 않으면 선점권이 해제 됩니다.*

|![note](https://user-images.githubusercontent.com/44664867/153594223-0ae9ba5a-f3d2-4e60-b347-a3d353a2aa40.gif)|
|---|
|노트 조회/생성/선택/편집|
|채널을 선택하면 채널에 속한 노트 리스트가 표시됩니다. 채널 부분에 hover하면 노트 생성 버튼이 나타납니다. 노트 선택을 하면 채팅 화면에서 노트 화면으로 전환됩니다. 현재 [control+단축키]로 효과를 줄 수 있습니다.|

<br>

## 아키텍처 🔍

<br>

- images

- description?

<br>

## 역할 분담

### Frontend
[김건형🐮](https://github.com/GeonHyeongKim):  [iOS App](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/frontend/ios)

[차효준🐶](https://github.com/chahtk): [Web App](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/frontend/web), 노트 기획

### Backend
[김지수🦉](https://github.com/SooKim1110): [인증 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/authServer), [노트 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/note-server), [게이트웨이](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/gateway), [Eureka 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/eureka-server)

[김지효🐻](https://github.com/njsh4261): [워크스페이스 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/workspace), [채팅 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/chat), [프리젠스 서버](https://github.com/njsh4261/SGS_Last_Punch/tree/dev/src/backend/presence)

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