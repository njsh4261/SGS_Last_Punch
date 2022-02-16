# Presence Server API Reference
- STOMP Client를 통해 접속
- STOMP 연결 예시는 `/src/main/resources/static/index.js` 참고
- 워크스페이스 입장 시점에 connect 함수 호출

## API List
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



## API 사용 시나리오

### 소켓 연결
- 사용자가 워크스페이스 메인 페이지에 진입할 때 STOMP connect 함수를 통해 `/ws/presence` 엔드포인트에 소켓 연결 시도
  - 연결이 정상적으로 성립된 경우 다음 동작을 절차적으로 실행
  - STOMP subscribe 함수를 통해 `/topic/workspace.{id}`에 대해 구독
  - `GET /presence/{id}` 메소드를 요청하여 워크스페이스 멤버들 상태 목록을 DB에서 가져옴
  - STOMP publish 함수를 통해 `/app/update`에 현재 유저가 `ONLINE` 상태라는 정보 메시지를 보냄  
- 프론트엔드는 소켓 정상 연결 후 받아온 멤버 상태 목록을 저장하고, 유저 상태 변화 메시지가 들어올 때마다 이 목록을 업데이트 해야 함



### 멤버 목록
- 프론트엔드는 멤버 상태 목록에 있는 유저는 해당 유저의 상태를 표시하고  목록에 없는 유저는 `OFFLINE` 상태로 표시
  - `userStatus`는 `ONLINE`, `ONLINE`, `ABSENT`, `BUSY`, `OFFLINE`, `DISCONNECTED` 중 하나이며, 유저 상태를 표시하기 위한 상태는 `DISCONNECT`를 제외한 나머지임
  - 상태 코드를 어떤 형태로 사용자에게 보여줄 지는 프론트엔드의 자율에 맡김 (e.g. '`ONLINE`: "온라인", `ABSENT`: 부재 중' 등)
  - 멤버 상태 목록에 `OFFLINE`으로 명시된 유저는 서비스 연결이 되지 않은 것처럼 `OFFLINE`으로 표시 (실제로는 서비스를 이용 중인 유저이지만, 개인의 선택으로 접속 상태를 표시하고 싶지 않은 경우 상태를 `OFFLINE`으로 보이도록 표시할 수 있음)

### 상태 변화 업데이트
- STOMP publish 함수를 통해 `/app/update`에 현재 유저의 상태 변화를 알리는 메시지를 보냄
- UpdateDto에 허용되는 `userStatus`는 위에서 언급한 것과 동일

### 소켓 연결 해제
- 사용자가 로그아웃을 할 경우 STOMP disconnect 함수 호출
- 다른 사용자가 로그아웃을 하거나 비정상적으로 연결이 종료된 경우, 프리젠스 서버는 소켓 연결이 끊김을 감지하고 해당 사용자가 연결 중이던 워크스페이스에 해당 유저의 상태가 `DISCONNECT`으로 변했다는 메시지를 송신함
  - 프론트엔드에서 어떤 유저의 상태가 `DISCONNECT`로 변했다는 것을 수신하면 해당 유저를 멤버 상태 목록에서 제거해야 함
