## 환경 변수

### .env

- .env는 보안을 위해 ignore
- 대신 템플릿을 보여주기 위해 env 파일 있음
- env 파일을 보고 .env 파일을 만들고 협의된 값을 넣는다.

## 도커로 실행

<br>

### 도커 설치

- 주소: https://www.docker.com/get-started

- 설치 확인은 cmd 창에 `docker -v`

<br>

### 이미지 파일 빌드 및 시작

- README가 있는 위치에서 `docker-compose up -d --build`

- http://localhost:3000 접속

### 명령어 정리

```
"build:image": "docker-compose up -d --build",
"remove:image": "docker rmi web_reactdockerize",
"start:container": "docker-compose up -d",
"clear:container": "docker rm -f reactdockerize",
"stop:container": "docker stop reactdockerize",
"restart:container": "docker start reactdockerize",
```

- npm이 깔려있다면 key 부분의 명령어 사용 가능(e.g. `npm run build:image`)
- 외에도 `package.json` 참고하여 명령어 사용가능
- **npm이 깔려있지 않다면 value 부분의 docker command 사용!**

## 디렉토리 구조

```
- types : 외부 라이브러리, 혹은 특정 파일에 대한 타입 정의
- src
|--- Api: api. called by 'modules'
|--- modules: redux module
|--- icon: image icon
|--- styles: global style, value
|--- routes: 로그인 상태에 따라 public, private 라우팅
|--- pages: 라우팅 되는 페이지. 여러 컴포넌트를 조합한다.
|--- component
      |--- common: 재사용되는 presenter 컴포넌트
      |--- topic: 특정 페이지
            |--- section: 페이지의 영역(옵셔널)
                  |--- container: index.tsx
                  |--- presenter
```