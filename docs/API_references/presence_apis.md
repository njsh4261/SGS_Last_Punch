# Presence Server API Reference
- STOMP Client를 통해 접속
- STOMP 연결 예시는 `/src/main/resources/static/index.js`에서 Javascript 부분 참고
- 워크스페이스 입장 시점에 connect 함수 호출
- 여러 채널을 구독하고 싶을 경우 각각의 채널에 대해 subscribe 함수 호출

| Protocol | Action/Method   | URL                      | description                              | DTO       | Return          | 호출 시점 |
|----------|-----------------|--------------------------|------------------------------------------|-----------|-----------------|-------|
| STOMP    | connect         | `/ws/presence`           | 소켓 연결 entry point                        | -         | -               | 연결 시  |
| STOMP    | publish         | `/app/update`            | 유저 상태 변화 메시지를 서버에 전송                     | UpdateDTO | UpdateDTO       | 서비스 중 |
| STOMP    | subscribe       | `/topic/workspace.{id}`  | `workspace.{id}`에 해당하는 exchange의 메시지를 구독 | -         | -               | 연결 시  |
| HTTP     | GET             | `/presence/{id}`         | `{id}`에 해당하는 워크스페이스의 멤버들의 상태 목록을 불러옴     | -         | List<UpdateDTO> | 서비스 중 |

- DTO의 모든 field는 String으로 입력
- UpdateDTO 예시
  ```
  {
    "workspaceId": "123",
    "userId": "456",
    "userStatus": "ONLINE"
  }
  ```
- `userStatus`는 `ONLINE`, `ONLINE`, `ABSENT`, `BUSY`, `OFFLINE` 중에 설정
- 로그아웃 혹은 비정상적 연결로 소켓 연결이 끊어진 멤버의 경우 서버에서 해당 멤버에 대해 `DISCONNECT` status 메시지를 publish (프론트엔드에서 `DISCONNECT`에 대한 처리 요망)
  - `OFFLINE`은 자신을 오프라인 상태로 표시하고 싶은 멤버를 위한 선택지, `DISCONNECT`와 구분하여 사용할 것
- 위에 명시하지 않은 상태를 입력할 경우 `UNKNOWN` status로 저장 및 상태 변화를 전파하게 됨
