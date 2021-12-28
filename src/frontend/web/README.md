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
