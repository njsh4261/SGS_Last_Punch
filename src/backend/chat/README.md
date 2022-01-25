# Chat
- 채팅 프로토타입 구현
- WebSocket, STOMP, RabbitMQ를 사용한 기본적인 채팅 기능
- 채널 분리 기능 구현

## How To Use Prototype
![image](https://user-images.githubusercontent.com/54832818/150924382-95512f7d-20df-41dd-bfce-de4f79168e99.png)
- user name, channel id를 입력하고 Connect 버튼 누르기
- 메시지를 입력하고 send를 누르면 메시지가 전송되고, 같은 채널에서 전송된 메시지들이 하단에 출력됨
- 같은 채널의 메시지만 볼 수 있고, 채널이 다르면 메시지가 보이지 않음
- Disconnect 버튼을 눌러서 소켓 연결을 해제할 수 있음

## URIs
- Entry point: `/chat`
- Publish message: `/pub/chat`
- Subscibe message: `/topic/channel.{channelId}`
- STOMP 연결 예시는 `/src/main/resources/static/index.html`에서 Javasript 부분 참고
