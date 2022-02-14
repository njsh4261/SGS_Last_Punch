# Chat Server API Reference
- STOMP Client를 통해 접속
- STOMP 연결 예시는 `/src/main/resources/static/index.html`에서 Javasript 부분 참고
- 여러 채널을 구독하고 싶을 경우 각각의 채널에 대해 subscribe 함수 호출

| Protocol | Action/Method | URL                           | description                   | DTO         | Return        | 호출 시점 |
|----------|---------------|-------------------------------|-------------------------------|-------------|---------------|-------|
| STOMP    | connect       | `/ws/chat`                    | 소켓 연결 entry point             | -           | -             | 연결 시  |
| STOMP    | publish       | `/app/chat`                   | 메시지를 서버에 전송                   | SendDTO     | Message       | 서비스 중 |
| STOMP    | subscribe     | `/topic/channel.{channelId}`  | {channelId}가 가리키는 채널의 메시지를 구독 | -           | -             | 연결 시  |
| HTTP     | POST          | `/chat/recent`                | 채팅 채널 입장 시 최근의 메시지를 불러옴       | EnterDTO    | Page<Message> | 연결 시  |
| HTTP     | POST          | `/chat/old`                   | 특정 시점을 기준으로 이전의 메시지를 불러옴      | GetOlderDTO | Page<Message> | 서비스 중 |

- DTO의 모든 field는 String으로 입력
- EnterDTO 예시
  ```
  {
    "channelId": "123"
  }
  ```

- SendDTO 예시
  ```
  {
    "authorId": "1",
    "channelId": "123",
    "content": "Test Message"
  }
  ```

- GetOlderDto
  ```
  {
    "channelId": "123",
    "dateTime": "2021-02-14 00:11:22"
  }
  ```
