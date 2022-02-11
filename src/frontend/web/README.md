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

## Snack?

*여러 협업 툴을 사용하면서 새 창을 키거나 알트탭은 그만!*

*Slack과 Notion의 기능을 합친 Snack으로 쾌적한 협업을 경험해보세요!*

*워크스페이스와 채널을 생성하고 팀원을 초대하여 **채팅**하고 노트를 만들어 **공동 편집**을 할 수 있습니다!*

<br>

## 주요 기능

TODO: 주요 기능과 로직에 대한 설명, 그리고 컴포넌트 및 로직 코드의 위치를 적는다

<br>

### 회원가입

이메일을 통해 회원가입을 할 수 있습니다.

- 이미지

<br>

### 로그인

유저 정보를 입력하고 성공하면 토큰을 localStorage에 저장합니다.

- image

<br>

### 웰컴 페이지

유저의 워크스페이스 리스트가 렌더링 됩니다.

- image

더보기를 통해 페이징된 결과를 응답받아 렌더링 합니다.

- image

워크스페이스를 선택하여 메인 페이지로 이동합니다.

- image

워크스페이스 개설 페이지로 이동합니다.

- image

로그아웃 합니다.

- image

<br>

### 워크스페이스 개설

워크스페이스 이름과 채널 이름을 입력하여 워크스페이스를 개설합니다.

- image

<br>

### 메인 페이지

워크스페이스 초대, 멤버 보기, 나가기가 가능합니다.

채널을 선택합니다. 선택된 채널에서는 초대, 멤버 보기, 나가기가 가능합니다.

헤더 우측의 쿠키를 누르시면 웰컴 페이지로 이동, 프로필, 로그아웃을 할 수 있는 드롭다운이 펼쳐집니다.

선택된 채널에서 채팅 관련 작업을 할 수 있습니다. 

선택된 채널에서 노트 관련 작업을 할 수 있습니다. 노트 목록 보기, 노트 생성, 노트 선택을 할 수 있습니다.

노트를 선택합니다. 실시간 공동 편집이 가능합니다. 편집은 **선점권**을 획득한 사람만 할 수 있고, 타이핑 종료시 선점권이 해제 됩니다.

<br>

## 기술 스택

- React: 최신 버전을 사용했습니다. 빠른 개발을 위해 CRA를 사용했기 때문에 반강제적인 선택이 됐습니다. 후에 외부 라이브러리를 사용할 떄 호환 문제를 겪고 버전에 신중해야 한다는 점을 몸으로 느꼈습니다.

- TypeScript: 정적 타입 지원으로 안전하고 편리함까지 제공해주는 타입스크립트에 대한 소문을 듣고 도전하기 위해 도입했습니다.

- Styled-Component: css를 컴포넌트로 관리하기 위해 선택했습니다.

- Redux: 상태의 전역 관리, Redux의 미들웨어를 사용해보기 위해 도전해보았습니다.

- Slate: 위지위그(WYSIWYG: What You See Is What You Get) 프레임워크입니다. 노트(공동편집) 기능 기획 단계에서 적절한 기능을 제공해주어 선택했습니다.

- stompJS: 서버 측에서 보다 편한 구현 및 확장성을 위해 선택하여 프로콜을 맞추기 위해 선택했습니다.

- sockJS: websocket이 지원되지 않는 브라우저에서도 API가 잘 동작되는 뛰어난 호환성을 지닌 라이브러리입니다.

<br>


## 디렉토리 구조

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
      |--- topic: 특정 화면에 대한 컴포넌트들
            |--- CreateWs: 워크스페이스 개설
            |--- Main: 메인의 사이드바 + 채팅
            |--- Note: 노트
            |--- Signin: 로그인
            |--- SignupEmail: 회원가입
            |--- Welcome: 워크스페이스 선택, 개설 버튼
```

<br>

## 실행

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
