# Snack - Web Front <img height="20px" width="20px" src="https://user-images.githubusercontent.com/44664867/153584703-0fc34cd1-0091-46de-94ad-290415fb5fc1.png">

*여러 협업 툴을 사용하면서 새 창을 키거나 알트탭은 그만!*

*Slack과 Notion의 기능을 합친 Snack으로 쾌적한 협업을 경험해보세요!*

*워크스페이스와 채널을 생성하고 팀원을 초대하여 **채팅**하고 노트를 만들어 **공동 편집**을 할 수 있습니다!*

<br>

## Hyojun Cha 🐶

항상 애정을 갖고 프로젝트에 참여하는 웹 개발자입니다!

나 뿐만 아니라 다른 사람도 사랑할 수 있는 멋진 프로젝트를 만들어 나가기 위해 노력하고 있습니다.

현재 프론트엔드에 집중하고 있지만 백엔드에 대한 관심도 놓지 않고 공부 중입니다.

제 프로젝트, 코드에 대한 질문, 피드백은 사소한 거라도 언제든지 환영입니다!

📬 chahtk@gmail.com

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

## 기능 💡

<br>

### 로그인/회원가입 페이지

|<img src="https://user-images.githubusercontent.com/44664867/153739297-75455016-4d3e-47a2-9bfe-656fafcddc72.gif" width="600px"></img>|<img src="https://user-images.githubusercontent.com/44664867/153588913-cdc4aaee-2b01-46f8-8eb5-cd070620e487.gif" width="600px"></img>|
|---|---|
|회원가입|로그인, 로그아웃|
|이메일 인증 후 회원가입|이메일로 로그인하여 localStorage에 access/refresh token 저장|

<br>

### 웰컴 페이지

유저의 워크스페이스 리스트가 렌더링 됩니다. 워크스페이스 더 보기, 선택, 개설, 로그아웃을 할 수 있습니다.

|<img src="https://user-images.githubusercontent.com/44664867/153590304-1ea5081d-62dc-4a1c-9363-2b7d3a3d255b.gif" width="600px"></img>|<img src="https://user-images.githubusercontent.com/44664867/153590298-72e25cc7-4a89-4610-b02f-31750eed0335.gif" width="600px"></img>|<img src="https://user-images.githubusercontent.com/44664867/153590300-635c7f76-c7ce-4086-a619-c8652a3684fe.gif" width="600px"></img>|
|---|---|---|
|더 보기|선택|개설|
|페이징된 결과를 불러옵니다|워크스페이스 페이지로 이동|새 워크스페이스 생성|


<br>

### 메인 페이지 & 채팅

|<img src="https://user-images.githubusercontent.com/44664867/153591700-641e26c7-8faf-4b02-8d08-430f50d85f4e.gif" width="600px"></img>|<img src="https://user-images.githubusercontent.com/44664867/155121065-c08ed786-a250-4dd8-b167-51e3ccfec134.png" width="650px"></img>|
|---|---|
|초대|멤버 보기|
|유저 검색 후 워크스페이스/채널에 초대|워크스페이스/채널에 참가한 멤버 상태 보기|

|<img src="https://user-images.githubusercontent.com/44664867/153592206-4a5aaa93-3499-404b-b0f7-901c4d4df11c.gif" width="600px"></img>|<img src="https://user-images.githubusercontent.com/44664867/155121523-e3d73506-691e-4c56-af28-75dfe2568856.gif" width="650px">|<img src="https://user-images.githubusercontent.com/44664867/153592212-0684d281-36af-422c-b72a-59f2ac252bb3.gif" width="600px">|
|---|---|---|
|웰컴페이지 이동, 로그아웃|프로필|채팅|
|쿠키를 눌러 웰컴페이지로 이동하거나 로그아웃|프로필 정보 모달(프리젠스 변경)|채팅 기능(UI 수정중)|

<br>

### 노트 기능

> *Snack에는 선점 개념이 있습니다. 동료끼리 동시에 편집하는 것은 때론 방해가 됩니다. 선점자만 문서 편집이 가능하고 실시간 업데이트 됩니다. 타이핑을 1.5초 동안 하지 않으면 선점권이 해제 됩니다.*

|![note](https://user-images.githubusercontent.com/44664867/153594223-0ae9ba5a-f3d2-4e60-b347-a3d353a2aa40.gif)|
|---|
|노트 조회/생성/선택/편집|
|채널을 선택하면 채널에 속한 노트 리스트가 표시됩니다. 채널 부분에 hover하면 노트 생성 버튼이 나타납니다. 노트 선택을 하면 채팅 화면에서 노트 화면으로 전환됩니다. 현재 [control+단축키]로 효과를 줄 수 있습니다.|

<br>

## 아키텍처

![image](https://user-images.githubusercontent.com/44664867/155122356-94f9373d-3a75-4d85-9db9-344674515d6d.png)

<br>

## 디렉토리 구조 🔍

```
- types : 외부 라이브러리, 혹은 특정 주제에 대한 타입 정의
- src
|--- Api: 주제별 API
|--- icon: 아이콘 이미지
|--- util: 재사용되는 함수
|--- hook: custom hook
|--- pages: 라우팅 되는 페이지. 여러 컴포넌트를 조합한다.
|--- styles: global style, theme
|--- routes: 로그인 상태에 따라 public, private 라우팅
|--- modules: Redux 모듈, ducks 패턴 적용
|--- constant: 상수
|--- component
      |--- common: 재사용되는 presenter 컴포넌트
      |  (topics: 특정 화면에 대한 컴포넌트들)
      |--- CreateWs: 워크스페이스 개설
      |--- Signin: 로그인
      |--- SignupEmail: 회원가입
      |--- Welcome: 워크스페이스 선택, 개설 버튼
      |--- Main: 메인 페이지
            |--- Aside: 사이드바 (채널 및 DM중인 사용자 리스트)
            |--- Note: 노트 (동시 편집을 위한 소켓, REST API)
            |--- Chat: 채팅 (채팅을 위한 소켓, REST API)
```

<br>

## 목표 및 회고 😎

### 목표

> 내가 진짜로 쓸 수 있는 Snack을 만들자!

내가 쓰기 위한 Snack의 모습은 아래와 같았습니다.

- UI/UX: Slack과 Notion의 UI를 잘 조합하여, 일관성 있고 Notion처럼 심플한 아름다움을 지닌 UI를 디자인! 처음 접하는 사람도 쉽게 사용할 수 있는 직관적인 UX!
- 유지보수 및 최적화: 직관적인 프로젝트 구조를 갖고 렌더링에 대한 최적화!


### 목표1: 심플하고 직관적인 UI/UX를 만들기 위한 노력

notion의 심플한 디자인을 베이스로 notion과 slack의 UI별 필요 기능이 무엇인지 분석하고, 우리가 사용할 기능들을 취합해 재구성 했습니다.

한 가지 예시로, 위의 스크린샷 `메인 페이지 & 채팅` 부분의 멤버 보기처럼 워크스페이스/채널에 관한 정보,작업은 각각의 이름을 누르면 같은 형태의 모달 창을 제공하여 일관성을 주었습니다. 유저의 프로필, 로그아웃 등은 채팅, 노트 어느 화면이든 동일하게 우측 상단의 쿠키 버튼을 통하도록 구현했습니다.

그리고 다양한 관점의 의견을 수용하기 위해 **피드백**을 받아 개선했습니다.

- 김지효님: 채널과 노트 화면의 일관성이 부족하다.

- 김건형님: 채팅 메시지에 시간 표시하는 위치, 간격 등에 대한 피드백.

- 캠프장님: notion을 베이스로 해서 심플한데... 지나치게 심플해서 아쉽다

- 홍 주임님: 채팅창이 메모장 느낌이다.

- 나 대리님: 메시지 별로 시간을 표시해주면 좋겠다. 채널과 노트에 대한 구분을 좀 더 명확히 알 수 있게 표시하면 좋겠다.

- 스무스팀: 서로의 작업물을 보여주다가 스무스팀의 로고를 스피너로 사용하는 것을 보고 영감을 얻어 쿠키(개인 설정) 애니메이션에 도입했습니다.

UI/UX에 대한 정량적인 평가는 어렵지만 캠프원 분들이 피드백을 주실 때 어렵지 않게 기능을 이용하는 것을 보고 UX측면에서 훌륭하다고 생각했고, UI에 대해서도 마지막 쯤엔 부정적인 평가 혹은 아쉬운 점에 대해 얘기하시는 분이 거의 없어 목표를 잘 이루었다고 판단합니다!

### 목표2: 최적화 및 유지보수를 위한 노력

#### - 모듈화

각 모듈에 대해 책임, 규모, 재사용성, 유지보수 등을 고려하려고 노력했습니다. 마찬가지로 정량적인 평가는 어렵다고 생각되지만 어떤 식의 노력을 했고 적절했는지에 대해 평가하겠습니다.

- `/api/handler.tsx`: 무려 30곳에서 호출되는 API handler입니다. 함수 오버로드를 이용해 `GET/POST/PUT/DELETE`에 대해 다른 파라미터를 받을 수 있게 선언했고 핵심적인 기능은 요청이 성공 응답을 받았는지에 대한 점검과 토큰 관련 처리입니다. 토큰 만료 응답이 오게 되면 `reissue API`를 통해 `access token`을 다시 받고 요청을 다시 해줍니다. 재사용성과 유지보수 측면에서 정말 뛰어난 모듈이라고 평가합니다.

- `/components/Common/`: 재사용되는 컴포넌트들이 있는 디렉토리입니다. 여러 곳에서 비슷하게 사용되는 스타일이나 컴포넌트를 모아 재사용 가능하게 만들었습니다. 사용 편의성을 위해 옵셔널 파라미터를 사용했습니다. 전체적으로 유지보수 때 편했지만 Input처럼 정말 범용적으로 쓸 수 있는 컴포넌트의 경우 props 설정이 너무 복잡해질 것 같아서 처음 생각할 때 만큼의 재사용성을 보여주진 못한 부분이 있습니다.

- `/modules/`: redux 모듈이 모인 디렉토리입니다. 현재 개발 규모에서 ducks 패턴이 유리하다고 판단되어 채택했습니다. redux를 처음 사용해 보았는데 처음에는 하나의 상태에 너무 많은 정보를 담으려고 했습니다. 예를들어 `userList`는 워크스페이스에 속한 유저들의 정보를 관리하는데, 여기에 프리젠스 정보(유저의 online, busy, absent, offline 상태를 나타냄)를 같이 관리하려고 했습니다. 혼자 개발할 때는 몰랐는데 팀원과 데모를 할 때, 다른 사용자의 프리젠스 정보를 업데이트할 때 `userList`를 포함한 컴포넌트들이 전부 리렌더링 된다는 사실을 깨달았습니다. 이를 통해 리덕스 모듈 또한 적절한 관심사 나누기가 필요하다는 것을 깨닫고 `presence`로 모듈을 분리했습니다.

- 외에도 각 컴포넌트들에 대해 버그 해결이나 유지보수 측면을 쉽게 하기 위해 기능별로 적절한 규모로 나누기 위해 꾸준히 리팩토링했습니다.

#### - React Hook

`역할에 따라 커스텀 훅을 분류하고 어떤 의도를 가진 훅인지 명확히 이해한다`라는 목표를 세웠습니다. props drilling을 막기 위해 적절한 컴포넌트 위치에서 hook을 사용하다보니 정확히 어떤 컴포넌트에서 훅을 사용했는지 가늠하기 어려웠고, 이런 이유 때문에 `/hooks` 디렉토리를 만들어서 용도 따라 훅을 분류했습니다. 버그 픽스, 코드 수정을 해야할 때 훨씬 용이했습니다.

- 로직이 간단한 훅은 따로 분류하지 않았고, 중요하거나 로직이 복잡해서 수정이 잦을 것 같은 훅을 위주로 분류 했습니다.

- 용도에 맞게 네이밍을하여 의도 파악을 하기 쉽게 했습니다.

- 로직이 복잡했던 채팅과 노트 기능의 경우 따로 디렉토리를 만들어 훅을 좀 더 세부적으로 나눴습니다.

  - `/chat/index`: 채팅의 초기 세팅을 위한 훅입니다. 최근 메시지를 불러오는 API 호출과 chatSocket 훅을 불러오고, `입력 중 핸들러(msgTypingHandler)`과 `채팅 메시지 보내기 핸들러(msgSubmitHandler)` 선언하여 리턴합니다. msgTypingHandler의 경우 디바운스 처리하여 서버에 불필요한 publish를 하지 않게 했습니다.

  - `/chat/chatSocket`: 채팅의 소켓 설정으로 워크스페이스의 채널 리스트와 유저 리스트에 대해 구독합니다. `입력 중`에 대한 메시지가 오면 `typingList`에 추가하고 setTimeout을 통해 일정 시간 후엔 리스트에서 제거하도록 했습니다. 또는 채팅 메시지가 오는 경우 `msgList`에 추가합니다. 만약 현재 선택된 채널 외에서 메시지가 온다면 채팅 알림만 표시합니다.

  - `/chat/chatScroll`: `IntersectionObserver API`를 사용하여 채팅창을 위로 올렸을 때 오래된 메시지를 가져오게 구현했습니다. handler에 여러가지 예외처리를 했는데, 해당 채널에 더 오래된 메시지가 없을 경우, 채팅이 몇 개 없어서 뷰포트에 타겟 엘리먼트가 계속 잡히는 경우 등에 로직을 수행하지 않게 얼리 리턴 하도록 했습니다.

  - `/note/noteSetup`: editor를 초기화하고 API를 통해 해당 노트의 초기 데이터(content+operations)를 가져와 적용합니다. 선점권자의 `typingTimer` 동작, 예외상황이었던 브라우저 종료 시 소켓을 disconnect 합니다.

  - `/note/noteSocket`: connect와 구독과 콜백, publish에 대한 핸들러가 있습니다. 전달받은 메시지 타입에 따라 `userList`, `owner`, `title`, `op`를 업데이트 합니다.

  - `/note/noteOPinterval`: [Dan Abramov의 useInterval](https://overreacted.io/making-setinterval-declarative-with-react-hooks/)을 기반으로 구현했습니다. 선점자는 operation의 큐를 일정 주기마다 REST API 서버에 업데트하고 성공 응답이 오면 응답에 포함된 timestamp값을 소켓 서버에 publish하여 다른 사용자들이 op를 요청하게끔 합니다.

- 채팅과 노트 개발 중 버그, 에러 등이 많이 발생하면서 잦은 수정을 해야 했는데 훅을 적절히 분리하여 생산성을 확실히 높였던 것 같습니다. 구체적인 수치는 표현할 수 없지만 '어느 컴포넌트에 어떤 로직을 수정해야 한다'라는 내용을 제 머리에 담을 필요가 없었기 때문에 스트레스 관리 측면에서 특히 탁월했습니다.

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
