# Chat Server API Reference
- STOMP Client를 통해 접속
- STOMP 연결 예시는 `/src/main/resources/static/index.html`에서 Javasript 부분 참고
- 여러 채널을 구독하고 싶을 경우 각각의 채널에 대해 subscribe 함수 호출

## API List
| Protocol | Action/Method | URL                           | description                   | DTO         | Return        | 호출 시점 |
|----------|---------------|-------------------------------|-------------------------------|-------------|---------------|-------|
| STOMP    | connect       | `/ws/chat`                    | 소켓 연결 entry point             | -           | -             | 연결 시  |
| STOMP    | publish       | `/app/chat`                   | 메시지를 서버에 전송                   | ReceiveDto     | Message       | 서비스 중 |
| STOMP    | subscribe     | `/topic/channel.{channelId}`  | {channelId}가 가리키는 채널의 메시지를 구독 | -           | -             | 연결 시  |
| HTTP     | POST          | `/chat/recent`                | 채팅 채널 입장 시 최근의 메시지를 불러옴       | EnterDTO    | Page<Message> | 연결 시  |
| HTTP     | POST          | `/chat/old`                   | 특정 시점을 기준으로 이전의 메시지를 불러옴      | GetOlderDTO | Page<Message> | 서비스 중 |

- DTO의 모든 field는 String으로 입력

- ReceiveDto 예시 (`type`이 `MESSAGE`인 경우)
  ```
  {
    "authorId": "1",
    "channelId": "123",
    "type": "MESSAGE",
    "content": "Test Message"
  }
  ```

- ReceiveDto 예시 (`type`이 `TYPING`인 경우)
  ```
  {
    "authorId": "1",
    "channelId": "123",
    "type": "TYPING"
  }
  ```
  - `type`이 `TYPING`일 때 `content`는 생략 가능

- EnterDTO 예시
  ```
  {
    "channelId": "123"
  }
  ```

- GetOlderDto
  ```
  {
    "channelId": "123",
    "dateTime": "2021-02-14 00:11:22"
  }
  ```



## API 사용 시나리오

### 사전 작업
- 사용자가 워크스페이스 메인 페이지에 진입할 때 워크스페이스 서버에 API 호출을 통해 워크스페이스의 채널 중 현재 사용자가 소속된 채널 목록 및 워크스페이스의 멤버 목록을 불러오고 이 목록들을 클라이언트에서 관리

### 소켓 연결
- STOMP connect 함수를 통해 `/ws/chat` 엔드포인트에 소켓 연결 시도
  - 연결이 정상적으로 성립된 경우 다음 동작을 절차적으로 실행
  - STOMP subscribe 함수를 통해 다음 topic들에 대해 일괄 구독
    - 현재 사용자가 소속된 모든 채널에 대해 `/topic/channel.{id}` topic을 구독
    - 워크스페이스의 모든 멤버에 대해 `/topic/channel.{workspaceId}-{userId1}-{userId2}` topic을 구독
      - `workspaceId`는 현재 입장한 워크스페이스의 id이며
      - `userId1`과 `userId2`에는 현재 사용자의 id와 워크스페이스 멤버의 id를 입력하되, `userId1 <= userId2`의 규칙으로 입력 (e.g. `/topic/channel.123-45-67`은 유효한 topic, `/topic/channel.123-98-32`는 유효하지 않음)

### 채팅 메시지 목록
- 프론트엔드는 각각의 채널과 DM을 구독한 이후 메시지를 수신했을 때 적절한 리스트에 해당 메시지를 추가하여 관리해야 함
- 채팅 채널에 입장 시 `POST /chat/recent` 메소드를 요청하여 가장 최근에 해당 채널에서 오간 메시지 목록을 DB에서 가져옴
- 사용자가 채팅 채널의 메시지 목록에 표시된 메시지들보다 더 이전의 메시지를 조회하고자 하는 경우, 기존 로컬 메시지 목록 중 가장 오래된 메시지의 `createDt`를 DTO에 포함하여 `POST /chat/old` 메소드를 요청하여 해당 메시지 바로 이전의 메시지들을 조회함


### 채팅 메시지 전송
- STOMP publish 함수를 통해 `/app/chat`에 메시지를 전송
- `ReceiveDTO`에서 `type`을 `MESSAGE`로 기입하는 경우, `content`를 담은 채팅 메시지를 전송
  - DB에 해당 메시지 저장
  - 해당 topic을 구독한 모든 사용자가 해당 메시지를 채팅 메시지 목록에서 확인하게 됨

### 메시지 입력 중 상태
- STOMP publish 함수를 통해 `/app/chat`에 메시지를 전송
- `ReceiveDTO`에서 `type`을 `TYPING`로 기입하는 경우, 현재 사용자가 채팅 메시지를 입력 중이라는 정보를 전송함
  - 일시적인 정보이므로 DB에 메시지를 저장하지 않음

#### 메시지 입력 중 상태: 권장 구현 방안
- 사용자가 메시지를 입력하기 시작헀을 때, `TYPING` 타입으로 해당 채널의 topic에 메시지 전송
- 하나의 채널에서 한 번 `TYPING` 타입의 메시지를 전송한 경우 다음 10초간 `TYPING` 타입의 메시지의 메시지를 채팅 서버로 보내지 않음
- 채팅 서버는 `TYPING` 타입의 메시지를 구독자들에게 전달
- 사용자 `John Doe`로부터 `TYPING` 타입의 메시지를 받았을 때, 클라이언트는 `John Doe 님이 메시지를 입력 중입니다.`라는 문구를 화면에 10초간 출력
- 다음 10초 후 `John Doe`로부터 `TYPING` 타입의 메시지가 다시 들어왔을 때 해당 문구 유지, 들어오지 않은 경우 해당 문구 제거

### 소켓 연결 해제
- 사용자가 로그아웃을 할 경우 STOMP disconnect 함수 호출
