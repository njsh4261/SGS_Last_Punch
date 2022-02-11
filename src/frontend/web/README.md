# Snack - Web Front

<br>

![Generic badge](https://img.shields.io/badge/17.0.2-React-skyblue.svg)
![Generic badge](https://img.shields.io/badge/4.5.4-TypeScript-green.svg)
![Generic badge](https://img.shields.io/badge/5.3.3-Styled%20Component-pink.svg)

![Generic badge](https://img.shields.io/badge/4.1.2-Redux-yellow.svg)
![Generic badge](https://img.shields.io/badge/0.59-Slate-yellowgreen.svg)
![Generic badge](https://img.shields.io/badge/6.1.2-stompJS-brightgreen.svg)
![Generic badge](https://img.shields.io/badge/1.5.2-sockJS-red.svg)

<br>

## Snack? <img height="20px" width="20px" src="https://user-images.githubusercontent.com/44664867/153584703-0fc34cd1-0091-46de-94ad-290415fb5fc1.png">

*여러 협업 툴을 사용하면서 새 창을 키거나 알트탭은 그만!*

*Slack과 Notion의 기능을 합친 Snack으로 쾌적한 협업을 경험해보세요!*

*워크스페이스와 채널을 생성하고 팀원을 초대하여 **채팅**하고 노트를 만들어 **공동 편집**을 할 수 있습니다!*

<br>

## 기술 스택 🛠

![Generic badge](https://img.shields.io/badge/17.0.2-React-skyblue.svg)

- 최신 버전을 사용했습니다. 빠른 개발을 위해 CRA를 사용했기 때문에 반강제적인 선택이 됐습니다. 후에 외부 라이브러리를 사용할 떄 호환 문제를 겪고 버전에 신중해야 한다는 점을 몸으로 느꼈습니다.

![Generic badge](https://img.shields.io/badge/4.5.4-TypeScript-green.svg)

- TypeScript: 정적 타입 지원으로 안전하고 편리함까지 제공해주는 타입스크립트에 대한 소문을 듣고 도전하기 위해 도입했습니다.

![Generic badge](https://img.shields.io/badge/5.3.3-Styled%20Component-pink.svg)

- Styled-Component: css를 컴포넌트로 관리하기 위해 선택했습니다.

![Generic badge](https://img.shields.io/badge/4.1.2-Redux-yellow.svg)

- Redux: 상태의 전역 관리, Redux의 미들웨어를 사용해보기 위해 도전해보았습니다.

![Generic badge](https://img.shields.io/badge/0.59-Slate-yellowgreen.svg)


- Slate: 위지위그(WYSIWYG: What You See Is What You Get) 프레임워크입니다. 노트(공동편집) 기능 기획 단계에서 적절한 기능을 제공해주어 선택했습니다.

![Generic badge](https://img.shields.io/badge/6.1.2-stompJS-brightgreen.svg)

- stompJS: 서버 측에서 보다 편한 구현 및 확장성을 위해 선택하여 프로콜을 맞추기 위해 선택했습니다.

![Generic badge](https://img.shields.io/badge/1.5.2-sockJS-red.svg)

- websocket이 지원되지 않는 브라우저에서도 API가 잘 동작되는 뛰어난 호환성을 지닌 라이브러리입니다.

<br>

## 디렉토리 구조 🔍

```
- types : 외부 라이브러리, 혹은 특정 주제에 대한 타입 정의
- src
|--- Api: 주제별 API
|--- modules: Redux 모듈, ducks 패턴 적용
|--- icon: 아이콘 이미지
|--- constant: 상수
|--- util: 재사용되는 함수
|--- hook: custom hook
|--- styles: global style, theme
|--- routes: 로그인 상태에 따라 public, private 라우팅
|--- pages: 라우팅 되는 페이지. 여러 컴포넌트를 조합한다.
|--- component
      |--- common: 재사용되는 presenter 컴포넌트
      |  (topics: 특정 화면에 대한 컴포넌트들)
      |--- CreateWs: 워크스페이스 개설
      |--- Main: 메인의 사이드바 + 채팅
      |--- Note: 노트
      |--- Signin: 로그인
      |--- SignupEmail: 회원가입
      |--- Welcome: 워크스페이스 선택, 개설 버튼
```

<br>

## 기능 💡

TODO: 주요 기능과 로직에 대한 설명, 그리고 컴포넌트 및 로직 코드의 위치를 적는다

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

## 개인 목표 및 회고 😎

[TODO] 프로젝트 하면서 느낀 것들

<br>

## 실행 🔥

git clone을 했을 때 실행할 수 있는 방법입니다.

<br>

### 환경변수

- `.env`는 보안을 위해 ignore되어 있습니다.
- `.env`의 template인 `env` 파일을 보고 `.env`을 만듭니다.
- 이 때, 값은 백엔드의 주소를 적습니다.

<br>

### NPM
```
npm i
npm start
```

<br>

### Docker

### 이미지 파일 빌드 및 시작

- `docker-compose.yml`이 있는 위치에서 `docker-compose up -d --build`

- http://localhost:3000 접속
